Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981Ab3ASK4q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 05:56:46 -0500
Received: from mxout2.iskon.hr ([213.191.128.81]:46427 "EHLO mxout2.iskon.hr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745Ab3ASK4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 05:56:44 -0500
X-Remote-IP: 213.191.128.133
Date: Sat, 19 Jan 2013 11:56:40 +0100
From: Zlatko Calusic <zlatko.calusic@iskon.hr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130112 Icedove/17.0.2
MIME-Version: 1.0
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org
References: <20130118234944.5C99C31C240@corp2gmr1-1.hot.corp.google.com>
In-Reply-To: <20130118234944.5C99C31C240@corp2gmr1-1.hot.corp.google.com>
Message-ID: <50FA7BE8.9040906@iskon.hr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: mmotm 2013-01-18-15-48 uploaded
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45/RELEASE,
	 bases: 20130119 #9104116, check: 20130119 clean
X-SpamTest-Envelope-From: zlatko.calusic@iskon.hr
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 41663 [Jan 19 2013]
X-SpamTest-Method: none
X-SpamTest-Rate: 0
X-SpamTest-SPF: none
X-SpamTest-Status: Not detected
X-SpamTest-Status-Extended: not_detected
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.01.2013 00:49, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2013-01-18-15-48 has been uploaded to
>
>     http://www.ozlabs.org/~akpm/mmotm/
>

WARNING: vmlinux.o(.text+0x43f025): Section mismatch in reference from 
the function release_firmware_map_entry() to the function 
.meminit.text:firmware_map_find_entry_in_list()
The function release_firmware_map_entry() references
the function __meminit firmware_map_find_entry_in_list().
This is often because release_firmware_map_entry lacks a __meminit
annotation or the annotation of firmware_map_find_entry_in_list is wrong.

-- 
Zlatko
