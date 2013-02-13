Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932789Ab3BMJwa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 04:52:30 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:1725 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932451Ab3BMJw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 04:52:28 -0500
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
Message-ID: <511B6248.3020506@broadcom.com>
Date: Wed, 13 Feb 2013 10:52:08 +0100
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-Version: 1.0
To: bskeggs@redhat.com
cc: "Peter Hurley" <peter@hurleysoftware.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Maarten Lankhorst" <maarten.lankhorst@canonical.com>,
        "Daniel J Blueman" <daniel@quora.org>,
        "Marcin Slusarz" <marcin.slusarz@gmail.com>
Subject: Re: [ 61/61] drm/nouveau: add lockdep annotations
References: <20130212203417.890993903@linuxfoundation.org>
 <20130212203426.021116247@linuxfoundation.org>
 <1360726523.3642.4.camel@thor.lan> <511B5DD0.1040103@broadcom.com>
 <1360748621.10139.0.camel@localhost>
In-Reply-To: <1360748621.10139.0.camel@localhost>
X-Enigmail-Version: 1.4.6
X-WSS-ID: 7D05BE5E1Z0442253-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2013 10:43 AM, Ben Skeggs wrote:
> On Wed, 2013-02-13 at 10:33 +0100, Arend van Spriel wrote:
>> On 02/13/2013 04:35 AM, Peter Hurley wrote:
>>> On Tue, 2013-02-12 at 12:35 -0800, Greg Kroah-Hartman wrote:
>>>> 3.7-stable review patch.  If anyone has any objections, please let me know.
>>>
>>> FWIW, I never saw this on 3.7 but it happened 1st time on 3.8-rcX
>>> I haven't tested this fix either.
>>
>> Dito.
>>
>> Gr. AvS
> Yeah, I don't believe anything could trigger it in 3.7.  It doesn't hurt
> anyway.

You are right. There could be other stable patches introducing a similar
issue in 3.7 later on. Better be prepared.

Gr. AvS


