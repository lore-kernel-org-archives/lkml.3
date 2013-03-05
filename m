Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab3CEIPV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 03:15:21 -0500
Received: from relay3.sgi.com ([192.48.152.1]:53701 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751913Ab3CEIPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 03:15:20 -0500
Date: Tue, 5 Mar 2013 02:15:19 -0600
From: Robin Holt <holt@sgi.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Robin Holt <holt@sgi.com>, hpa@sgi.com,
        linux-kernel@vger.kernel.org
Subject: Re: Revert commit 5dcd14ecd4 - breaks EFI boot with SLES11
 elilo.efi
Message-ID: <20130305081519.GA19165@sgi.com>
References: <20130228205206.GC3438@sgi.com>
 <512FC697.3090608@zytor.com>
 <20130228210910.GD3438@sgi.com>
 <512FC82B.40909@zytor.com>
 <CAE9FiQU3FBwEiC86N1RC8=aMdN09EbUmRcsWP0yof7bmxBhPew@mail.gmail.com>
 <512FE3AE.4070903@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <512FE3AE.4070903@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 03:09:34PM -0800, H. Peter Anvin wrote:
> On 02/28/2013 03:02 PM, Yinghai Lu wrote:
> > 
> > Good, kexec is not only one.
> > 
> > ELILO has one.
> >         5  ELILO
> > 
> > We need switch/case to have different fields set for it.
> > 
> 
> I wouldn't consider that "good", but it's a bloody good thing we have
> bootloader IDs.

What is the planned course of action here.  With this commit applied,
I still cannot boot.  Is there something you are waiting for from me?

Thanks,
Robin
