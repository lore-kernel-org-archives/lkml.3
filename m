Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab3KVHfA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 02:35:00 -0500
Received: from mail.vm.ouaza.com ([88.190.240.227]:60501 "EHLO
	mail.vm.ouaza.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab3KVHe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 02:34:57 -0500
Date: Fri, 22 Nov 2013 08:34:54 +0100
From: Raphael Hertzog <hertzog@debian.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Some kernel module options not showing up in modinfo
Message-ID: <20131122073454.GE17630@x230-buxy.home.ouaza.com>
References: <20131121144758.GA6515@x230-buxy.home.ouaza.com>
 <87li0hyxfl.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87li0hyxfl.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 22 Nov 2013, Rusty Russell wrote:
> Raphael Hertzog <hertzog@debian.org> writes:
> > Hello,
> >
> > I noticed that some options are not visible in the modinfo output. For
> > instance "modinfo lockd" reports this on my Debian sid system:
[...]
> > Multiple other options are defined by way of module_param_call(...) like
> > nlm_grace_period, nlm_timeout, nlm_updport, nlm_tcpport.
> 
> Yes, the module_param() macro adds a type description.  The
> module_param_call() does not.

Couldn't they be displayed without any type or with a type "unknown" ?

parm: nlm_grace_period

or 

parm: nlm_grace_period:unknown

Cheers,
-- 
Raphaël Hertzog ◈ Debian Developer

Discover the Debian Administrator's Handbook:
→ http://debian-handbook.info/get/
