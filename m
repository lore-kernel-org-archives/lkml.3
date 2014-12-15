Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235AbaLOLpb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 06:45:31 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:46966 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbaLOLp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 06:45:28 -0500
Message-ID: <548EC9D4.6080706@cantab.net>
Date: Mon, 15 Dec 2014 11:45:24 +0000
From: David Vrabel <dvrabel@cantab.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Juergen Gross <jgross@suse.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        david.vrabel@citrix.com, boris.ostrovsky@oracle.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, mmarek@suse.cz,
        linux-kbuild@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH 2/4] xen: synchronize include/xen/interface/xen.h
 with xen
References: <1418321065-10212-1-git-send-email-jgross@suse.com> <1418321065-10212-3-git-send-email-jgross@suse.com>
In-Reply-To: <1418321065-10212-3-git-send-email-jgross@suse.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/14 18:04, Juergen Gross wrote:
> The header include/xen/interface/xen.h doesn't contain all definitions
> from Xen's version of that header. Update it accordingly.

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

David
