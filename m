Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbaAGRXE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 12:23:04 -0500
Received: from mailout1.w2.samsung.com ([211.189.100.11]:25281 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbaAGRXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 12:23:01 -0500
X-AuditID: cbfec37c-b7f0d6d0000057bc-58-52cc37f4f807
Message-id: <52CC37F1.6080704@samsung.com>
Date: Tue, 07 Jan 2014 10:22:57 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Joerg Roedel <joro@8bytes.org>
Cc: akpm@linux-foundation.org, alexander.h.duyck@intel.com,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH v2] dma-debug: enhance dma_debug_device_change() to check
 for mapping errors
References: <1384376168-2148-1-git-send-email-shuah.kh@samsung.com>
 <20131230141511.GC2799@8bytes.org> <52C700BC.1010200@samsung.com>
 <20140107142625.GC2742@8bytes.org> <52CC1691.9040603@samsung.com>
 <20140107151200.GA29041@8bytes.org>
In-reply-to: <20140107151200.GA29041@8bytes.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t9hP90v5meCDJ49VraYs34Nm8XJZb+Z
	LTpnb2C3uLxrDpvF158ODqweTw7OY/LYOesuu8fiPS+ZPE7M+M3i8XmTXABrFJdNSmpOZllq
	kb5dAlfGzsYm5oLPrBXPj+1kbGC8wtLFyMEhIWAiMeEYVxcjJ5ApJnHh3nq2LkYuDiGBZYwS
	3e/3Qzm9TBJ37n1hh3A2Mkpc7VrCBtLCK6Al8fH5NCYQm0VAVeLOv/lgNpuAusTn1zvYQWwh
	ATmJpiWrmUFsUYEIiVdnJ7JA9ApK/Jh8D8wWEVCSuP65lRVkAbPAFEaJ9obprCAJYYEkiWnz
	QYaCbP7IKLFvxgGwSZwCBhJ/T04D62YWsJZYOWkbI4QtL7F5zVtmiM3KEn8un2KC+FNRYvtq
	qwmMIrOQ7J6FpHsWku4FjMyrGMVKi5MLipPSUyuM9YoTc4tL89L1kvNzNzFCoqZmB+O9rzaH
	GAU4GJV4eG+onQkSYk0sK67MPcQowcGsJMK7UQ4oxJuSWFmVWpQfX1Sak1p8iJGJg1OqgdGn
	9MJutk1rvG4WPmFr5erns5p/vjB1Wo8JN9PupX+cYju75hydnHqwQPz+0e9eV1LiTb2dXuiJ
	qne53G8PC3jLOTFgX+y00qsXbkTldCgtdWDj+cm6Wv/t/cWP1V7fv7dz6zd9nc9O9V7Vb7cU
	Ty/6uUQ4XqhV0NGOxa+l6+HTt0tCRA2u5CuxFGckGmoxFxUnAgAd7We2eAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2014 08:12 AM, Joerg Roedel wrote:
> On Tue, Jan 07, 2014 at 08:00:33AM -0700, Shuah Khan wrote:
>> This patch and a follow-on cocinelli warning fix patch are in
>> linux-next. Would you like me to send a patch relative to the change
>> in linux-next or cut a new patch against the latest Linus's git. I
>> can go either way. We just have to remember to drop those two
>> patches from linux-next.
>
> Please do a patch against linus.git and drop the two patches from
> linux-next. Over which tree did they go into linux-next anyway?
>
>

ok. It went through mm tree.

-- Shuah


-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
