Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757294Ab3KLWVV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 17:21:21 -0500
Received: from mailout1.w2.samsung.com ([211.189.100.11]:43551 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757249Ab3KLWVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 17:21:11 -0500
X-AuditID: cbfec37b-b7fa96d00000716e-11-5282a9d5a4d1
Message-id: <5282A9C8.9050304@samsung.com>
Date: Tue, 12 Nov 2013 15:20:56 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.0
MIME-version: 1.0
To: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: akpm@linux-foundation.org, joro@8bytes.org, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com, Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH] dma-debug: enhance dma_debug_device_change() to check for
 mapping errors
References: <1384289478-9899-1-git-send-email-shuah.kh@samsung.com>
 <5282A7D5.7050406@intel.com>
In-reply-to: <5282A7D5.7050406@intel.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t9hP92rK5uCDJ6ssLCYs34Nm8XJZb+Z
	LTpnb2C3uLxrDpvF158ODqweTw7OY/LYOesuu8fiPS+ZPE7M+M3i8XmTXABrFJdNSmpOZllq
	kb5dAlfG8Q3fmQpuslZs77zO3sC4j6WLkZNDQsBEYvHVR2wQtpjEhXvrgWwuDiGBZYwSt27O
	YIFwepkkZv35yAxSJSSwkVFi8f16EJtXQEvi/uUrYJNYBFQlHt39xAhiswmoS3x+vYMdol5O
	omnJarBeUYEIiaOrn7FC9ApK/Jh8D6xXRMBQYtu1t6wgy5gF2hglnvS1gp0kLBAvsfrCIhaI
	QUkSh1fuA2vmFNCUWLZyOdhQZgFriZWTtjFC2PISm9e8hTpUWeLP5VNMXYwcQK8pSmxfbTWB
	UWQWktWzkHTPQtK9gJF5FaNYaXFyQXFSemqFkV5xYm5xaV66XnJ+7iZGSMxU72C8+9XmEKMA
	B6MSD69FTFOQEGtiWXFl7iFGCQ5mJRFeh1qgEG9KYmVValF+fFFpTmrxIUYmDk6pBsYZpvM7
	+x8wz7Syt7rxdd61lxY32i5PXmkhE5KW++fxZFeetze8s9ILvkm8VTmXXl+uU/OS9+hXhaM/
	eyT/SIefPvJxz5yn8cV1EZo70hK4r240yFv42UG60+/FxoWbJ8r94Fez/KhmIcqxQ/ylzPrb
	hQfkNO+/s+44prI+bS3397qmqw5LfvQpsRRnJBpqMRcVJwIA5AVT1ncCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2013 03:12 PM, Alexander Duyck wrote:
> I think this might be overdoing the error checking by a bit.  I would
> much rather have the DMA leaked error be visible than have it buried
> under messages about the failure to check for DMA errors.  In my mind
> the DMA buffer leak is much more serious than the failure to check for
> mapping errors.
>

I agree DMA leak message is more important. Would you like to see just 
one message if mapping errors are found? Instead of printing the entire 
stacktrace like it does now, it could just do warn.

-- Shuah


-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
