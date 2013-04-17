Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966722Ab3DQOwy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 10:52:54 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:43920 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966466Ab3DQOwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 10:52:53 -0400
Subject: Re: Cannot add new efi boot entry
From: joeyli <jlee@suse.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Matt Fleming <matt.fleming@intel.com>, matthew.garrett@nebula.com,
        cbouatmailru@gmail.com, ccross@android.com, keescook@chromium.org,
        Tony Luck <tony.luck@intel.com>, linux-efi@vger.kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
In-Reply-To: <1366210184.23707.69.camel@linux-s257.site>
References: <516B1ED3.9040900@suse.cz>
	 <1366106168.23707.9.camel@linux-s257.site> <516D23B5.4070209@intel.com>
	 <516EB1B6.7050506@suse.cz>  <1366210184.23707.69.camel@linux-s257.site>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Apr 2013 22:51:34 +0800
Message-ID: <1366210294.23707.70.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 三，2013-04-17 於 22:50 +0800，joeyli 提到：
> 於 三，2013-04-17 於 16:29 +0200，Jiri Slaby 提到：
> > On 04/16/2013 12:11 PM, Matt Fleming wrote:
> > > On 16/04/13 10:56, joeyli wrote:
> > >> I think I just got the same situation on my side with Acer machine. I am
> > >> trying Matthew's new patchset hope can avoid this situation:
> > >>
> > >> https://lkml.org/lkml/2013/4/15/473
> > > 
> > > Please do let us know whether the patches work for you.
> > 
> > Hmm, where did efi_query_variable_store in 3/3 come from?
> > 
> 
> here:
> https://git.kernel.org/cgit/linux/kernel/git/mfleming/efi.git/commit/?h=urgent&id=a6e4d5a03e9e3587e88aba687d8f225f4f04c792
> 
> Matthew's 3 patches all merged to Matt's efi git tree.

Forgot mention, in urgent branch

> 
> 
> Thanks
> Joey Leeg
> 

Joey Lee

