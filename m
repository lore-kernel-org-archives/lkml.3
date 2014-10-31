Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759274AbaJaK7e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 06:59:34 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:46920 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758015AbaJaK7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 06:59:31 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-97-54536b90ff2e
Message-id: <54536B5B.1050604@samsung.com>
Date: Fri, 31 Oct 2014 11:58:35 +0100
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Organization: Samsung Poland R&D Center
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Icedove/31.1.2
MIME-version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Linux API <linux-api@vger.kernel.org>,
        linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Tejun Heo <tj@kernel.org>,
        Ryan Lortie <desrt@desrt.ca>,
        Simon McVittie <simon.mcvittie@collabora.co.uk>, daniel@zonque.org,
        David Herrmann <dh.herrmann@gmail.com>, Paul Moore <pmoore@redhat.com>,
        "casey.schaufler@intel.com" <casey.schaufler@intel.com>,
        marcel@holtmann.org, tixxdz@opendz.org,
        javier.martinez@collabora.co.uk, alban.crequy@collabora.co.uk
Subject: Re: [PATCH 00/12] Add kdbus implementation
References: <54520A21.20404@samsung.com> <54521697.1030900@samsung.com>
 <20141030144709.GA19721@kroah.com> <545297CC.6020306@samsung.com>
 <20141030231310.0b65b762@alan.etchedpixels.co.uk>
In-reply-to: <20141030231310.0b65b762@alan.etchedpixels.co.uk>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t/xK7oTsoNDDNbN17S4svUIk8XfScfY
	LW6sWMBk0fT3FYtF9zUWi3mtR1ksJk35y2bRvHg9m8XR3wUWu+csZrE481vXYvP3DjaLy7vm
	sFl8+/SL0eLztV/sFu0rbjNarPy9nc3i1/KjjA5CHr9/TWL0+Pv8OovHjVkdrB47Z91l91i/
	ezm7x+I9L5k8Nq3qZPO4c20Pm8f+uWvYPVpPbmL1WPHrCLvH+31X2TzOLACyPm+S89i+ezlL
	AH8Ul01Kak5mWWqRvl0CV0b3tMOsBX2sFRf/PmZsYPzP3MXIySEhYCIx58BJKFtM4sK99Wxd
	jFwcQgJLGSWmd6xmhXA+MUpcn3CfFaSKV0BLYv7CJ4xdjBwcLAKqEstbrEDCbAJGEt8ObQAb
	xC+gLvFu21MmEFtUIESi9UoLG0SroMSPyfdYQGwRoMXNr14zgsxnFrjMIrF8RgdYkbCAscSk
	E28YIRbvZ5TouQyR4BSwk1i99hsLyGJmoA1TpuSChJkF5CU2r3nLPIFRcBaSHbMQqmYhqVrA
	yLyKUTS1NLmgOCk910ivODG3uDQvXS85P3cTIySSv+5gXHrM6hCjAAejEg+vxpegECHWxLLi
	ytxDjBIczEoivP/Sg0OEeFMSK6tSi/Lji0pzUosPMTJxcEo1MC5xfP3RoSja64Ta9mhv3ok/
	NRvdAhQd0+N/Lsn5bRNy9tX5/euiTNXzF5zjWfCZ91uCW8THNXPfNZekfmv8WxRk95+pZYNt
	rL5EeWV1U/jsKRen7ldfuq4/YO3jTFa5Ddbb09m5tqmFXK/WkTlz62fWTenP4dd/abHackeX
	v3Z37CxZe/v/fyWW4oxEQy3mouJEAL7kCmTCAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-10-31 00:13, One Thousand Gnomes wrote:
>>> The core calls are already mediated by LSM today, right?  We don't want
>>> anyone to be parsing the data stream through an LSM, that idea got
>>> rejected a long time ago as something that is really not a good idea.
>>
>> Parsing data is out of question, of course, but this is not what we were
>> proposing.
> 
> Why is it out of the question. If it's a socket you can just a BPF filter
> on it, so why can't kdbus support similar basic functionality ?

Fair point.  I think that none of us simply considered this till now.

Thanks
-- 
Karol Lewandowski, Samsung R&D Institute Poland
