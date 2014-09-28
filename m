Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbaI1Kp2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 06:45:28 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:52177 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865AbaI1KpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 06:45:24 -0400
Message-ID: <5427E6C0.1070208@plexistor.com>
Date: Sun, 28 Sep 2014 13:45:20 +0300
From: Boaz Harrosh <boaz@plexistor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Jens Axboe <axboe@fb.com>, Boaz Harrosh <boaz@plexistor.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Dmitry Monakhov <dmonakhov@openvz.org>
CC: Ross Zwisler <ross.zwisler@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCHSET 0/5 v2] brd: partition fixes
References: <53FDF7AD.5000709@plexistor.com> <54044759.9080103@gmail.com> <540EEE2C.1090801@plexistor.com> <540F0DDF.3010907@fb.com>
In-Reply-To: <540F0DDF.3010907@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2014 05:25 PM, Jens Axboe wrote:
<>
> 
> I will drop the 3/5 patch (do that one separately) and queue up and test.
> 

Jens hi

I'm reminding you of these brd bug fixes. Yes they are bug fixes for a driver
no one cares about. But it is a great pity if an unwanted user-mode accessible
parameter will hit a release. Lets solve this now please?

Is there anything I can help with?

Thanks
Boaz

