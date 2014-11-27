Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751640AbaK0XiQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 18:38:16 -0500
Received: from tundra.namei.org ([65.99.196.166]:51352 "EHLO namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbaK0XiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 18:38:14 -0500
Date: Fri, 28 Nov 2014 10:37:58 +1100 (AEDT)
From: James Morris <jmorris@namei.org>
To: Kees Cook <keescook@chromium.org>
cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Pranith Kumar <bobby.prani@gmail.com>
Subject: Re: [PULL] seccomp update (next)
In-Reply-To: <CAGXu5jJQK39HnyVMmVrerY+wiL+P80JTE8nscDa7Wyyk1hZing@mail.gmail.com>
Message-ID: <alpine.LRH.2.11.1411281037250.28866@namei.org>
References: <20141125194319.GA9328@www.outflux.net> <alpine.LRH.2.11.1411270022240.22560@namei.org> <20141127084614.209450b9@canb.auug.org.au> <CAGXu5jJQK39HnyVMmVrerY+wiL+P80JTE8nscDa7Wyyk1hZing@mail.gmail.com>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2014, Kees Cook wrote:

> > That would be because your tree is based on v3.17 and Kees' is based on
> > v3.18-rc6 ...
> 
> James, I can base on whatever you like. I can do v3.17, or even
> against your security-next. It seems everyone uses something
> different. :)

It's best to track my next branch as your upstream.


-- 
James Morris
<jmorris@namei.org>

