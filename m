Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbaA1Nb3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 08:31:29 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:57520 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750911AbaA1Nb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 08:31:28 -0500
Message-ID: <52E7B129.6060704@hurleysoftware.com>
Date: Tue, 28 Jan 2014 08:31:21 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Stas Sergeev <stsp@list.ru>, Pavel Machek <pavel@ucw.cz>
CC: Margarita Manterola <margamanterola@gmail.com>,
        Maximiliano Curia <maxy@gnuservers.com.ar>,
        Stas Sergeev <stsp@users.sourceforge.net>,
        Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Caylan Van Larson <i@caylan.net>
Subject: Re: Large pastes into readline enabled programs causes breakage from
 v2.6.31 onwards
References: <5291E92F.7010609@hurleysoftware.com> <1385428582-5577-1-git-send-email-peter@hurleysoftware.com> <529D236E.4020002@hurleysoftware.com> <529D9DCD.5080003@list.ru> <529E0E1F.4010303@hurleysoftware.com> <529E2E92.4010004@list.ru> <529E6F02.70506@hurleysoftware.com> <529F7B35.4050509@list.ru> <20140128120317.GA28381@xo-6d-61-c0.localdomain> <52E79FBE.7040904@list.ru>
In-Reply-To: <52E79FBE.7040904@list.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2014 07:17 AM, Stas Sergeev wrote:
> 28.01.2014 16:03, Pavel Machek пишет:
>> Hi!
>>
>>>>> How is this different from the unpatched kernel?
>>>>> In the unpatched kernel, if you happen on reader side
>>>>> to enable icanon while n_tty received all but VEOF (is this
>>>>> possible at all?),
>>>>> then the buffer will be flushed, and the remaining VEOF
>>>>> will get you a nice EOF.
>>>>> So, in the unpatched kernel you get EOF because the buffer
>>>>> gets wiped.
>>>> ???
>>>>
>>>> Testcase output from 3.12 w/o patch:
>>> OK, sorry, after a year of rot of my patch in bugzilla, I've
>>> completely forgot the pre-conditions, which is that the
>>> buffer is not discarded, just not pushed.
>>>
>>>> Consider the total brute-force approach; a shadow read_flags that
>>>> distinguishes a real EOF receive from the fake EOF push initiated
>>>> by the patch.
>> Was this solved somehow?
> Wasn't this already applied?

Yes, this was applied and is on the mainline master branch,
so will appear in 3.14-rc1.

Regards,
Peter Hurley

