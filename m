Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106AbaFBSyQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 14:54:16 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:58791 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577AbaFBSyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 14:54:15 -0400
From: Andy Lutomirski <luto@amacapital.net>
X-Google-Original-From: Andy Lutomirski <luto@mit.edu>
Message-ID: <538CC855.4080201@mit.edu>
Date: Mon, 02 Jun 2014 11:54:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.15-rc8 ... and merge window for 3.16
References: <CA+55aFwSLmJ1kLO-zNm944Q-=oYYH2Lo0W14Dn0mbj91V5MNFA@mail.gmail.com>
In-Reply-To: <CA+55aFwSLmJ1kLO-zNm944Q-=oYYH2Lo0W14Dn0mbj91V5MNFA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2014 07:37 PM, Linus Torvalds wrote:
> I was really hoping that rc7 would be the last rc, but it appears that
> reality is once against conspiring against my well-laid plans, and is
> forcing me to do an rc8. It's not like there were a lot of changes,
> but the last-minute dcache fixes in particular made it not really sane
> to just make a final release without another week of testing.


AFAIK, Zebra is still broken on 3.15.  Should something like this be
applied:

http://article.gmane.org/gmane.linux.kernel.stable/91782

--Andy
