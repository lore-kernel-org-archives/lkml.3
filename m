Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136Ab3EHP7b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 11:59:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51858 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756515Ab3EHP73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 11:59:29 -0400
MIME-Version: 1.0
In-Reply-To: <20130508154216.GA24838@kroah.com>
References: <1367996197-32748-1-git-send-email-tiwai@suse.de>
	<20130508154216.GA24838@kroah.com>
Date: Wed, 8 May 2013 23:59:27 +0800
Message-ID: <CACVXFVM09z5kGsrVa38SneX46XrFD3Ydj9_Z8BB44=w6mqn=PQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] firmware: Fix usermodehelper deadlock at shutdown
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 8, 2013 at 11:42 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the second time this has been sent, right?  Any differences from
> the first set?

Sorry to not see that.

> I'll get to these after 3.10-rc1 is out, thanks.

I think we need to discuss the patch further, see my comments on
patches, :-)

Thanks,
--
Ming Lei
