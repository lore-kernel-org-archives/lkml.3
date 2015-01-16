Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257AbbAPTgv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 14:36:51 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:43299 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755956AbbAPTgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 14:36:47 -0500
Message-ID: <54B9684E.6020903@uw.edu>
Date: Fri, 16 Jan 2015 11:36:46 -0800
From: Harry Edmon <harry@uw.edu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: 3.18.2 crashes on Supermicro X10DRL-i motherboard
References: <54B00F11.9050605@uw.edu>
In-Reply-To: <54B00F11.9050605@uw.edu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/15 09:25, Harry Edmon wrote:
> I have a system with a Supermicro X10DRL-i motherboard and dual Xeon E5-2620 
> processors.   The system runs fine under 3.17.7, but crashes under 3.18.1 and 
> 3.18.2.   Below is the crash dump and kernel configuration file.   Does anyone 
> have any suggestions short of kernel bisecting?  Thanks.
>
I have verified that 3.18.3 fixes problem with this motherboard. Thanks to all 
concerned.
-- 
Dr. Harry Edmon
harry@uw.edu, 206-543-0547, FAX: 206-543-0308
Director of IT, College of the Environment and
Director of Computing, Dept of Atmospheric Sciences
University of Washington, Box 351640, Seattle, WA 98195-1640
