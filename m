Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab3BDXvc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 18:51:32 -0500
Received: from smtp12.ono.com ([62.42.230.20]:3307 "EHLO resmaa12.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754356Ab3BDXvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 18:51:31 -0500
X-Greylist: delayed 334 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Feb 2013 18:51:30 EST
Message-ID: <51104830.7060005@ono.com>
Date: Tue, 05 Feb 2013 00:45:52 +0100
From: =?UTF-8?B?SkEgTWFnYWxsw7Nu?= <jamagallon@ono.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130114 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Problems with late 3.8-rc5 and 3.8-rc6 on i686
References: <20130201201332.GA2965@wolff.to> <20130204232827.GA14752@wolff.to>
In-Reply-To: <20130204232827.GA14752@wolff.to>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2013 12:28 AM, Bruno Wolff III wrote:
> On Fri, Feb 01, 2013 at 14:13:32 -0600, Bruno Wolff III
> <bruno@wolff.to> wrote:
>>
>> One is that the rtkit-daemon service fails to start up and the
>> other is that there are issues with X. One one machine with an
>> rv280 based video card the background image doesn't show up in gdm
>> and I can't enter a password in gdm. C-A-F2 does get me back to a
>> vt. On another machine with a nv28 based video card I get the Oh no
>> something went wrong page, but again I can still use C-A-F2 to get
>> to a vt.
>
> I am still seeing this with 3.8.0-0.rc6.git1.1.fc19.i686.PAE.
>
> However, I have found the GUI issues are because gnome is waiting on
> the rtkit-daemon and once it times out, things are OK.

I had also problems with this and other daemons...
If you are using systemd, check if rtkit wants to run with PrivateTmp=yes.
If this is so, then check that your /tmp is _not_ a symlink, but
a real dir...

-- 
J.A. Magallon <jamagallon()ono!com>        \               Winter is coming...
