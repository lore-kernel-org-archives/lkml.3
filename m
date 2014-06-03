Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932622AbaFCON6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 10:13:58 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:36083 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932443AbaFCON5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 10:13:57 -0400
Message-ID: <538DD821.9000401@gmail.com>
Date: Tue, 03 Jun 2014 08:13:53 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Prankul Garg <prankul.iiitm@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: perf tools[ARM]:Not able to detect [kernel.kallsyms] dso on Qualcomm
 MSM 8974
References: <loom.20140603T154538-510@post.gmane.org>
In-Reply-To: <loom.20140603T154538-510@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/3/14, 8:02 AM, Prankul Garg wrote:
> Qualcomm MSM 8974 is not able to detect [kernel.kallsyms] dso either with
> Hardware or Tracepoint events while Exynos do.

Add -v to perf-record and perf-report.

And try:
perf report -D | grep kallsyms

Do you see something like:
0 0 0xd8 [0x58]: PERF_RECORD_MMAP -1/0: [0(0xffffffff9fffffff) @ 
0xffffffff81000000]: x [kernel.kallsyms]_text

David
