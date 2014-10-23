Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290AbaJWKuH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 06:50:07 -0400
Received: from smtp-out-101.synserver.de ([212.40.185.101]:1065 "EHLO
	smtp-out-101.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932211AbaJWKuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 06:50:02 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 25897
Message-ID: <5448DD58.7030705@metafoo.de>
Date: Thu, 23 Oct 2014 12:50:00 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.8.1
MIME-Version: 1.0
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Brian Vandre <bvandre@gmail.com>
CC: gregkh@linuxfoundation.org, jic23@kernel.org,
        alexandre.belloni@free-electrons.com, linux-iio@vger.kernel.org,
        marex@denx.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Staging: iio: adc: fix line over 80 characters
References: <cover.1413858979.git.bvandre@gmail.com> <cover.1413931615.git.bvandre@gmail.com> <ec4b497827f6c7615f6b5eef5669144f8c68d034.1413931615.git.bvandre@gmail.com> <20141022042115.GA2530@sudip-PC>
In-Reply-To: <20141022042115.GA2530@sudip-PC>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2014 06:21 AM, Sudip Mukherjee wrote:
> On Tue, Oct 21, 2014 at 05:56:47PM -0500, Brian Vandre wrote:
>> This fixes the 2 checkpatch.pl warnings:
>> WARNING: line over 80 characters
>>
> please check your patch with --strict option of checkpatch.pl , and you will get :
> "Alignment should match open parenthesis" .

Those checkpatch warnings are suggestions, not hard requirements. The idea 
is to improve code legibility, but if the change has the adverse effect the 
warning can and should be ignored. Also when making a change you should keep 
the existing indention style of a file.

- Lars
