Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302AbbATONF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 09:13:05 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:47339 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbbATOND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 09:13:03 -0500
Message-ID: <54BE6264.4090901@gmail.com>
Date: Tue, 20 Jan 2015 15:12:52 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Johannes Stezenbach <js@sig21.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: mtk.manpages@gmail.com, arnd@arndb.de, ebiederm@xmission.com,
        gnomes@lxorguk.ukuu.org.uk, teg@jklm.no, jkosina@suse.cz,
        luto@amacapital.net, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org, daniel@zonque.org, dh.herrmann@gmail.com,
        tixxdz@opendz.org
Subject: Re: [PATCH v3 00/13] Add kdbus implementation
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org> <20150119180642.GA27957@sig21.net> <20150119183806.GA8479@kroah.com> <20150119201906.GA337@sig21.net> <20150119203155.GA15441@kroah.com> <20150119233812.GA1874@sig21.net> <20150120011359.GE865@kroah.com> <20150120105712.GA6260@sig21.net> <20150120112609.GA17198@kroah.com> <20150120132437.GB7545@sig21.net>
In-Reply-To: <20150120132437.GB7545@sig21.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2015 02:24 PM, Johannes Stezenbach wrote:
> On Tue, Jan 20, 2015 at 07:26:09PM +0800, Greg Kroah-Hartman wrote:
>> On Tue, Jan 20, 2015 at 11:57:12AM +0100, Johannes Stezenbach wrote:

>>> My guess is that the people porting from QNX were just confused
>>> and their use of D-Bus was in error.  Maybe they should've used
>>> plain sockets, capnproto, ZeroMQ or whatever.
>>
>> I tend to trust that they knew what they were doing, they wouldn't have
>> picked D-Bus for no good reason.
> 
> The automotive developers I had the pleasure to work with would
> use anything which is available via a mouse click in the
> commercial Embedded Linux SDK IDE of their choice :)
> Let's face it: QNX has a single IPC solution while Linux has
> a confusing multitude of possibilities.

Greg, from my spell in IVI, I too have to say your faith in the
wisdom of IVI developers' choices is touching. I think D-Bus was 
in the main picked because it had some nice features, but then 
people realized it had no bandwidth, and the solution has been 
"make D-Bus faster", rather than "maybe we should explore 
other (mixed model) solutions". This isn't to say that I'm
against adding kdbus, but I don't think there's much strength to
the argument you make above.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
