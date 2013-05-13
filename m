Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618Ab3EMDJ3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 23:09:29 -0400
Received: from nm12-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.140]:21351 "HELO
	nm12-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751812Ab3EMDJ1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 23:09:27 -0400
X-Greylist: delayed 330 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 May 2013 23:09:27 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 135808.88487.bm@omp1058.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=VgYp2HewI7mO1LBx+FMZWicfgHYO+BS3dZBzuO5AnrR6QDL6EYTgHhKQeZeqCHeGj2PUxhpGcFRCZfBRZOVti9TYhnbAXowrFFlduY6AR7f3A/6q7/z+yKzAQX0zcbdAxyc1CxwAFffX7X/LRV+oCyHk5lMy2sWbgRquCoCftvQ=;
X-YMail-OSG: roqpa90VM1ltXikfTd9M0QBkDUEwKneRgrJOCwbeFsepsg2
 b79gKFup7_iFR13RzDDJtZGJpXNeN4zAMcy6Ju__LYnN5Cd4z9MmLl2BgrYd
 wJAMw0scdzuFnqT_KAE5CLFAQCsLpcgsJcOdFs.yemIm5pg4hCoJJlfZSn8n
 3f3Y41VJqFeuELCdb8lvFCzg.gF6qeJ1nZxQgNXICVYOVxFGL0_Ol7651Dp9
 FGEhtBAOejvqAileUSRKTBD96niAixC7ySyaeSEme458HpAKRYDA_FY16k7A
 4YXB7KtUvVElTtnJukuG5v9lJ19BHLE9fyiRhAFDozuuPgScuHR05xXEX9fM
 2tRQwSIdcIPmJ86fuCrRerGz6tjDxDYo8SYj7Hd6afbo6opaVwV3.Sz26uF9
 9E3_w2gXYvrfvLPTh1S.dRJUnRSTW1BvsEbhwRRsKhEfskqPcyaTYgUtEEps
 vmZwK93jf7tU5_RiWUDr0Cm5WDRfQobD4dBXDZ6EoN1p5c6tkN1oOKvqvuyS
 o_yKFNiz1ir3iS2FpMfjALcVcF_Hjbqo-
X-Rocket-MIMEInfo: 002.001,KiBTb3JyeSBSZS1zZW5kaW5nIGFzIHBsYWluIHRleHQuCgoKRGVhciBNci4gTWVsIEdvcm1hbiwKCkkgaGF2ZSBvbmUgcXVlc3Rpb24gYWJvdXQgbWVtb3J5IGNvbXBhY3Rpb24uCktlcm5lbCB2ZXJzaW9uOiBrZXJuZWwtMy40IChBUk0pCkNoaXBzZXQ6IFF1YWwtQ29tbSBNU004OTMwIGR1YWwtY29yZS4KCldlIHdhbnRlZCB0byBlbmFibGUgQ09ORklHX0NPTVBBQ1RJT04gZm9yIG91ciBwcm9kdWN0IHdpdGgga2VybmVsLTMuNC4KQnV0IFFDIGNvbW1lbnRlZCB0aGF0LCBlbmFibGluZyBjb21wYWN0aW9uIG8BMAEBAQE-
X-Mailer: YahooMailWebService/0.8.141.536
References: <1310394396.24243.YahooMailNeo@web162006.mail.bf1.yahoo.com>
 <20110711145448.GI15285@suse.de>
 <1310462107.89450.YahooMailNeo@web162007.mail.bf1.yahoo.com>
 <20110712093510.GB7529@suse.de>
 <1310484381.60694.YahooMailNeo@web162011.mail.bf1.yahoo.com> <20110712154404.GD7529@suse.de> <1368414026.58026.YahooMailNeo@web160103.mail.bf1.yahoo.com>
Message-ID: <1368414236.21785.YahooMailNeo@web160106.mail.bf1.yahoo.com>
Date: Sun, 12 May 2013 20:03:56 -0700 (PDT)
From: PINTU KUMAR <pintu_agarwal@yahoo.com>
Reply-To: PINTU KUMAR <pintu_agarwal@yahoo.com>
Subject: [Query] Performance degradation with memory compaction (on QC chip-set)
To: Mel Gorman <mgorman@suse.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <1368414026.58026.YahooMailNeo@web160103.mail.bf1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sorry Re-sending as plain text.


Dear Mr. Mel Gorman,

I have one question about memory compaction.
Kernel version: kernel-3.4 (ARM)
Chipset: Qual-Comm MSM8930 dual-core.

We wanted to enable CONFIG_COMPACTION for our product with kernel-3.4.
But QC commented that, enabling compaction on their chip-set is causing performance degradation for some streaming scenarios (from the beginning).

I wanted to know is this possible always?
We used compaction with exynos processor and did not observe any performance degradation.


All,
Does any one observed any performance problem (on any chipset) by enabling compaction?


Please let me know your comments.
It will be helpful to decide on enabling compaction or not.


Thank You.
With Regards,
Pintu





>
>
>>________________________________
>> From: Mel Gorman <mgorman@suse.de>
>>To: Pintu Agarwal <pintu_agarwal@yahoo.com> 
>>Sent: Tuesday, 12 July 2011 8:44 AM
>>Subject: Re: How to verify memory compaction on Kernel2.6.36??
>> 
>>
>>On Tue, Jul 12, 2011 at 08:26:21AM -0700, Pintu Agarwal wrote:
>>>  
>>> Actually I enabled compaction without HUGETLB support. Hope this is fine.
>>>  
>>
>>In terms of compaction yes. In terms of your target application, I don't
>>know.
>>
>>> Then I wrote a sample kernel module to allocate physical pages using kmalloc.
>>> (By passing the memory size from sample user space application and passing to this kernel module via ioctl calls)
>>>  
>>
>>The allocations will not be accessible to userspace without additional
>>driver support to map the pages in userspace.
>>
>>> Using these application, I request for total number of physical pages of the desired order(from commandline of user app).
>>> And at the sametime verifying the buddyinfo before and after the allocation.
>>> A sample output of my application is as
follows:-
>>> ============================================================
>>> /opt/pintu # ./app_pinchar.bin
>>> Node 0, zone   Normal     34      9     13      7     11      6      2      2      3      1     36
>>> Node 0, zone  HighMem     53    194    110     36     21      7      1      2      3      2      6
>>> Page block order: 10
>>> Pages per block:  1024
>>> Free pages count per migrate type at
order       0      1      2      3      4      5      6      7      8      9     10
>>> Node    0, zone   Normal, type    Unmovable     32      5      8      5     11      5      2      0      2      0      0
>>> Node    0, zone   Normal, type  Reclaimable      1     
2      4      2      0      0      0      1      1      1      0
>>> Node    0, zone   Normal, type      Movable      1      0      1      0      0      1      0      1      0      0     35
>>> Node    0, zone   Normal, type      Reserve      0      0      0     
0      0      0      0      0      0      0      1
>>> Node    0, zone   Normal, type      Isolate      0      0      0      0      0      0      0      0      0      0      0
>>> Node    0, zone  HighMem, type    Unmovable      1      0      2      3      1     
0      0      1      2      1      1
>>> Node    0, zone  HighMem, type  Reclaimable      0      0      0      0      0      0      0      0      0      0      0
>>> Node    0, zone  HighMem, type      Movable     21    194    108     33     20      7      1      1     
1      1      4
>>> Node    0, zone  HighMem, type      Reserve      0      0      0      0      0      0      0      0      0      0      1
>>> Node    0, zone  HighMem, type      Isolate      0      0      0      0      0      0      0      0      0      0     
0
>>> Number of blocks type     Unmovable  Reclaimable      Movable      Reserve      Isolate
>>> Node 0, zone   Normal           82            4           73            1            0
>>> Node 0, zone  HighMem           14            0           81            1            0
>>>
-------------------------------------------------------------------------------------------
>>>  
>>> Enter the page order(in power of 2) : 512
>>
>>Page order 512? That's a good trick. I assume you means order 9 for 512
>>pages.
>>
>>> Enter the number of such block : 200
>>> ERROR : ioctl - PINCHAR_ALLOC - Failed, after block num = 72 !!!
>>> DONE.....
>>> 
>>
>>72 corresponds almost exactly to the number of order-9 pages that were
>>free when the application started.
>>
>>> ==========================================================================================
>>> Node 0, zone   Normal    100     84     53     36     33     21      8      0      3     
2      0
>>> Node 0, zone  HighMem    844    744    612    357    200     91      8      3      4      1      6
>>> 
>>
>>There is almost no free memory in the Normal zone at this stage of
>>the test implying that even perfect compaction of all pages would
>>still not result in a new order-9 page while obeying watermarks.
>>
>>> ============================================================
>>>  
>>> Then I want to verify whether compaction is working for the all allocation request or not.
>>
>>Read /proc/vmstat but I doubt it was used much. Memory was mostly
>>unfragmented when the application started. It is likely that after
>>72 order-9 pages there was not enough free
memory to compact further
>>and that is why the allocation failed.
>>
>>> OR, at least how far compaction is helpful in these scenarios.
>>>  
>>
>>Compaction would have been helpful in the event the system has been
>>running for some time and was fragmented. This test looks like it
>>happened very close to boot so compaction would not have been requried.
>>
>>> Please let me know how compaction can be effective in such cases where order 8,9,10 pages are requested.
>>>  
>>
>>Compaction reduces allocation latencies when memory is fragmented for
>>high-order allocations like this. I'm not what else you are expecting
>>to hear.
>>
>>-- 
>>Mel Gorman
>>SUSE Labs
>>
>>
>>
>
>
