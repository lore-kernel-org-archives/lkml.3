Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676AbbAQTzW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 14:55:22 -0500
Received: from mail-qg0-f48.google.com ([209.85.192.48]:57631 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbbAQTzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 14:55:20 -0500
Message-ID: <54BABE25.4030009@landley.net>
Date: Sat, 17 Jan 2015 13:55:17 -0600
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] out out damn perl
References: <54AC72AF.5090609@landley.net> <20150106155024.5efa209d575fff4868758482@linux-foundation.org> <20150117080136.GA7396@amd>
In-Reply-To: <20150117080136.GA7396@amd>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2015 02:01 AM, Pavel Machek wrote:
> 
> On Tue 2015-01-06 15:50:24, Andrew Morton wrote:
>> On Tue, 06 Jan 2015 17:41:35 -0600 Rob Landley <rob@landley.net> wrote:
>>
>>> Commit e6023367d779 added perl back to the kernel build in -rc6.
>>> Replace 39 lines of perl with 4 lines of shell script.
...
>> - The offending commit has cc:stable, so have a think about adding a
>>   cc:stable to this one as well.
> 
> Actually, I don't think this should go to stable. I like the patch,
> but it is not a bug, and certainly not serious enough one.

As long as the kernel doesn't make a habit of it, I don't care if
there's a release or two embedded developers should skip. Under ideal
conditions BSPs only tend to update about once every 18 months, and
that's the _good_ ones.

Rob
