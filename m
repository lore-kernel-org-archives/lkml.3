Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282Ab3CDSVO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 13:21:14 -0500
Received: from mx02.imt-systems.com ([81.30.145.140]:52958 "EHLO
	mx02.imt-systems.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758637Ab3CDSVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 13:21:09 -0500
X-Greylist: delayed 355 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Mar 2013 13:21:09 EST
X-DKIM: Sendmail DKIM Filter v2.8.3 ucsinet10.imt-systems.com r24IF7tx004524
Message-ID: <5134E4AB.2010504@imt-systems.com>
Date: Mon, 04 Mar 2013 19:15:07 +0100
From: Morten Stevens <mstevens@imt-systems.com>
Organization: IMT-Systems GmbH
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: =?UTF-8?B?TWloYWkgRG9uyJt1?= <mihai.dontu@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: e1000e: nic does not work properly after cold power on
References: <20130304124631.2ac730f3@mdontu-l.dsd.ro>
In-Reply-To: <20130304124631.2ac730f3@mdontu-l.dsd.ro>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.628 () DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,RP_MATCHES_RCVD,SPF_PASS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.03.2013 11:46, Mihai Donțu wrote:
> Hi,
>
> I apologize in advance for posting on two lists at once and for not
> even being subscribed to e1000-devel.
>
> Ever since upgrading to 3.8.x, I'm unable to use my wired connection
> (e1000e - Intel Corporation 82579LM Gigabit) immediately after power
> on. I have to boot into an older kernel (3.2.0 I happen to have around)
> and _then_ boot into 3.8.1. There are no errors in dmesg that I can
> see. The only one behaving strangely is NetworkManager who simply says
> the device is managed and skips it. Also, there's no 'link becomes
> ready' in dmesg either (and I swear the cable is plugged in).

Hi,

Can you reproduce this with linux 3.9-rc1? 3.9-rc1 has the latest 
upstream driver (e1000e 2.2.14) which contains many bugfixes.

Best regards,

Morten
