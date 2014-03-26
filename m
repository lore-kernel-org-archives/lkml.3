Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133AbaCZPO2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 11:14:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33131 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759AbaCZPO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 11:14:26 -0400
Message-ID: <5332EECD.7070307@infradead.org>
Date: Wed, 26 Mar 2014 08:14:21 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Mitchel Humpherys <mitchelh@codeaurora.org>
CC: Rob Landley <rob@landley.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] Documentation/SubmittingPatches: remove references
 to patch-scripts
References: <1395791373-3694-1-git-send-email-mitchelh@codeaurora.org>	<1395791373-3694-3-git-send-email-mitchelh@codeaurora.org> <CAMuHMdWommWuhG=OcSwkqD9uyFdqfj7iccaF64uMsQsqh9GY+Q@mail.gmail.com>
In-Reply-To: <CAMuHMdWommWuhG=OcSwkqD9uyFdqfj7iccaF64uMsQsqh9GY+Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2014 01:51 AM, Geert Uytterhoeven wrote:
> (cc akpm, who still uses these scripts, while the rest of the world
> moved to git ;-)

no, some of us still use quilt.

> 
> On Wed, Mar 26, 2014 at 12:49 AM, Mitchel Humpherys
> <mitchelh@codeaurora.org> wrote:
>> The link to the tarball for Andrew Morton's patch scripts is dead. These
>> scripts don't seem to be used for kernel development these days anyways
>> so just rip out all references to them.
>>
>> Signed-off-by: Mitchel Humpherys <mitchelh@codeaurora.org>
>> ---
>>  Documentation/SubmittingPatches       | 5 -----
>>  Documentation/ja_JP/SubmittingPatches | 5 -----
>>  Documentation/zh_CN/SubmittingPatches | 4 ----
>>  3 files changed, 14 deletions(-)
>>
>> diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
>> index af80689517..3294469efd 100644
>> --- a/Documentation/SubmittingPatches
>> +++ b/Documentation/SubmittingPatches
>> @@ -75,11 +75,6 @@ There are a number of scripts which can aid in this:
>>  Quilt:
>>  http://savannah.nongnu.org/projects/quilt
>>
>> -Andrew Morton's patch scripts:
>> -http://userweb.kernel.org/~akpm/stuff/patch-scripts.tar.gz
>> -Instead of these scripts, quilt is the recommended patch management
>> -tool (see above).
>> -
>>
>>
>>  2) Describe your changes.
>> diff --git a/Documentation/ja_JP/SubmittingPatches b/Documentation/ja_JP/SubmittingPatches
>> index ff6cb5729c..5d6ae639bf 100644
>> --- a/Documentation/ja_JP/SubmittingPatches
>> +++ b/Documentation/ja_JP/SubmittingPatches
>> @@ -98,11 +98,6 @@ dontdiff ファイルには Linux カーネルのビルドプロセスの過程
>>  Quilt:
>>  http://savannah.nongnu.org/projects/quilt
>>
>> -Andrew Morton's patch scripts:
>> -http://userweb.kernel.org/~akpm/stuff/patch-scripts.tar.gz
>> -このリンクの先のスクリプトの代わりとして、quilt がパッチマネジメント
>> -ツールとして推奨されています(上のリンクを見てください)。
>> -
>>  2) パッチに対する説明
>>
>>  パッチの中の変更点に対する技術的な詳細について説明してください。
>> diff --git a/Documentation/zh_CN/SubmittingPatches b/Documentation/zh_CN/SubmittingPatches
>> index 788ab47303..1d3a10f874 100644
>> --- a/Documentation/zh_CN/SubmittingPatches
>> +++ b/Documentation/zh_CN/SubmittingPatches
>> @@ -82,10 +82,6 @@ Documentation/SubmittingDrivers 。
>>  Quilt:
>>  http://savannah.nongnu.org/projects/quilt
>>
>> -Andrew Morton 的补丁脚本:
>> -http://userweb.kernel.org/~akpm/stuff/patch-scripts.tar.gz
>> -作为这些脚本的替代，quilt 是值得推荐的补丁管理工具(看上面的链接)。
>> -
>>  2)描述你的改动。
>>  描述你的改动包含的技术细节。
>>
>> --
>> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
>> hosted by The Linux Foundation


-- 
~Randy
