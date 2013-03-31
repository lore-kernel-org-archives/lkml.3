Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840Ab3CaQYr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 12:24:47 -0400
Received: from mail.active-venture.com ([67.228.131.205]:61703 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523Ab3CaQYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 12:24:46 -0400
X-Originating-IP: 108.223.40.66
Date: Sun, 31 Mar 2013 09:24:48 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Tony Chung <tonychung00@gmail.com>
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 2/2] watchdog: fix w83627hf_wdt reboot due to timeout
 expired
Message-ID: <20130331162448.GA19349@roeck-us.net>
References: <1364695148-5605-1-git-send-email-tonychung00@gmail.com>
 <1364695148-5605-2-git-send-email-tonychung00@gmail.com>
 <20130331041115.GA13304@roeck-us.net>
 <CAHyaeP2YgVFaE77xayFuSGwHWc9yZZ9KZjLveXD+QvipKxW=qQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHyaeP2YgVFaE77xayFuSGwHWc9yZZ9KZjLveXD+QvipKxW=qQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 31, 2013 at 08:45:54AM -0700, Tony Chung wrote:
> How about this?
> 
> -       t &= ~0xC0;               /* disable keyboard & mouse turning off
> -                                   watchdog */
> +       t &= ~0xE0;               /* clear timeout occurred and disable keyboard
> +                                    & mouse turning off watchdog */
> 
Ys, only make it 0xD0. Looks like I was fighting with binaries last night and lost.

Guenter
