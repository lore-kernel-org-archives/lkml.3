Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975AbaENTVO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 15:21:14 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:53470 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108AbaENTVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 15:21:13 -0400
MIME-Version: 1.0
In-Reply-To: <20140514191122.GA7659@phenom.dumpdata.com>
References: <20140514191122.GA7659@phenom.dumpdata.com>
Date: Wed, 14 May 2014 15:21:12 -0400
X-Google-Sender-Auth: dzYaV-hMyd9Cp8AwYyXuUJAR_7U
Message-ID: <CA+5PVA5LHMir9W3ksw7LjssUAp_gK3MtvEy8NiDOoPeB9f3ZmA@mail.gmail.com>
Subject: Re: Backport request to stable of two performance related fixes for
 xen-blkfront (3.13 fixes to earlier trees)
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        xen-devel@lists.xenproject.org, felipe.franciosi@citrix.com,
        roger.pau@citrix.com, jerry.snitselaar@oracle.com,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 3:11 PM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> The following distros are affected:

> (x) Fedora 17 (3.8 and 3.9 in updates)
> (x) Fedora 18 (3.8, 3.9, 3.10, 3.11 in updates)
> (v) Fedora 19 (3.9; 3.10, 3.11, 3.12 in updates; fixed with latest update to 3.13), supported until TBA
> (v) Fedora 20 (3.11; 3.12 in updates; fixed with latest update to 3.13), supported until TBA

The net effect of all of the above is that all currently supported
Fedora versions already have the fixes.  Highlights one of the major
reasons we rebase the kernel in Fedora, even at the cost of fighting
the regressions that inevitably come with that.  Just an FYI for those
keeping track at home.

josh
