Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932487Ab3CNMNJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 08:13:09 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:34976 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab3CNMNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 08:13:07 -0400
MIME-Version: 1.0
In-Reply-To: <1363261359.25976.224.camel@thor.lan>
References: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
	<1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
	<CANN689HvZK3gHyxRBPZyXwz2cJfheiEoQMA23oRARMCp=7GUCQ@mail.gmail.com>
	<1363106846.27803.174.camel@thor.lan>
	<CANN689HX1VAURYZL4=ixOSwim2LdYDgZyORtfUffrc4JCqK4xQ@mail.gmail.com>
	<1363223574.25976.135.camel@thor.lan>
	<CANN689Fe7K-+Mf1is9GaS0bjDuYaTd8AtBMjLvAVAkNy+QLmuw@mail.gmail.com>
	<1363261359.25976.224.camel@thor.lan>
Date: Thu, 14 Mar 2013 05:13:05 -0700
Message-ID: <CANN689F_+TuMKhFQHLQko9Yr7H_Z-AscKzvaPjbnTa6STDNRNA@mail.gmail.com>
Subject: Re: [PATCH v5 00/44] ldisc patchset
From: Michel Lespinasse <walken@google.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Sasha Levin <levinsasha928@gmail.com>,
        Dave Jones <davej@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 4:42 AM, Peter Hurley <peter@hurleysoftware.com> wrote:
> On Thu, 2013-03-14 at 00:25 -0700, Michel Lespinasse wrote:
>> Its not too late to run away from it and preserve your sanity (as well
>> as that of the next person working on the tty layer :)
>
> The long-term plan is to migrate it to lib so it won't be a maintenance
> burden to tty.

That only moves the problem though, and makes sense only if we know of
another place where an unfair rwsem is desired...

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
