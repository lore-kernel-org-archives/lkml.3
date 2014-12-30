Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735AbaL3Oez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 09:34:55 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:57829 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbaL3Oey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 09:34:54 -0500
Message-ID: <54A2B807.1020202@hurleysoftware.com>
Date: Tue, 30 Dec 2014 09:34:47 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Emmanuel Grumbach <egrumbach@gmail.com>, Jiri Kosina <jkosina@suse.cz>
CC: Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: iwlwifi-driver card doesn't work with 3.19-rc2+
References: <alpine.LNX.2.00.1412301427430.31609@pobox.suse.cz> <CANUX_P0=wJiKrR4cUgEN=LO+eQ2byprz0K9m9QxzJc+kf4+_bA@mail.gmail.com>
In-Reply-To: <CANUX_P0=wJiKrR4cUgEN=LO+eQ2byprz0K9m9QxzJc+kf4+_bA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/30/2014 09:23 AM, Emmanuel Grumbach wrote:
> On Tue, Dec 30, 2014 at 3:33 PM, Jiri Kosina <jkosina@suse.cz> wrote:
>>
>> Hi,
>>
>> I just booted current Linus' tree (5faa0154fe33) on my x200s thinkpad, and
>> wifi doesn't work. iwconfig is telling me that wlan0 interface has no
>> wireless extensions.
>>
> 
> So why do you used them?
> They have been deprecated for a couple of years now. You should be
> using nl80211 based tools such as iw.

A couple of years is not very long where userspace is concerned.

Regards,
Peter Hurley

