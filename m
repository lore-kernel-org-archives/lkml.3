Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356AbaJVOAe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 10:00:34 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:35061 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbaJVOAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 10:00:30 -0400
From: Nix <nix@esperi.org.uk>
To: Johan Hovold <johan@kernel.org>
Cc: Paul Martin <pm@debian.org>, Daniel Silverstone <dsilvers@debian.org>,
        Oliver Neukum <oliver@neukum.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [3.16.1 BISECTED REGRESSION]: Simtec Entropy Key (cdc-acm) broken in 3.16
References: <878um4tg09.fsf@spindle.srvr.nix>
	<1409569752.24385.12.camel@linux-fkkt.site>
	<874mwnosz1.fsf@spindle.srvr.nix> <871tqe2zqt.fsf_-_@spindle.srvr.nix>
	<20141011195108.GA8275@thinkpad.nowster.org.uk>
	<87y4smz1l0.fsf@spindle.srvr.nix> <20141012185845.GB2786@localhost>
	<878uklynq9.fsf@spindle.srvr.nix> <20141014083432.GB7958@localhost>
	<871tq04fiy.fsf@spindle.srvr.nix> <20141022101458.GK2113@localhost>
Emacs: because extension languages should come with the editor built in.
Date: Wed, 22 Oct 2014 15:00:22 +0100
In-Reply-To: <20141022101458.GK2113@localhost> (Johan Hovold's message of
	"Wed, 22 Oct 2014 12:14:58 +0200")
Message-ID: <87fveg19xl.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-dcc1-Metrics: spindle 1182; Body=6 Fuz1=6 Fuz2=6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 Oct 2014, Johan Hovold uttered the following:

> On Wed, Oct 22, 2014 at 10:31:17AM +0100, Nix wrote:
>> On 14 Oct 2014, Johan Hovold verbalised:
>> 
>> > On Sun, Oct 12, 2014 at 10:36:30PM +0100, Nix wrote:
>> >> I have checked: this code is being executed against a symlink that
>> >> points to /dev/ttyACM0, and the tcsetattr() succeeds. (At least, it's
>> >> succeeding on the kernel I'm running now, but of course that's 3.16.5
>> >> with this commit reverted...)
>> >
>> > You could verify that by enabling debugging in the cdc-acm driver and
>> > making sure that the corresponding control messages are indeed sent on
>> > close.
>> 
>> I have a debugging dump at
>> <http://www.esperi.org.uk/~nix/temporary/cdc-acm.log>; it's fairly
>
> What kernel were you using here? The log seems to suggest that it was
> generated with the commit in question reverted.

Wurgle. I think I was probably using the wrong one, as you suggest.
Hell. That's no use at all is it. Still, at least you know what it looks
like when it works. :)

I'll retry with the right one.

> What kernel version are you using? And do you have autosuspend enabled?

3.16.6 (but it's happened for 3.16.* obviously). No autosuspend (no
*way* can this box suspend, but it only draws a couple of watts so I
don't care).

-- 
NULL && (void)
