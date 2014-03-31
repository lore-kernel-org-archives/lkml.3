Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336AbaCaK5j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 06:57:39 -0400
Received: from natasha.panasas.com ([209.166.131.148]:55728 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbaCaK5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 06:57:38 -0400
Message-ID: <53394A11.6060204@panasas.com>
Date: Mon, 31 Mar 2014 13:57:21 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [do_xor_speed] WARNING: CPU: 0 PID: 1 at init/main.c:708 do_one_initcall()
References: <20140331003825.GA11782@localhost> <53391483.9010800@panasas.com> <20140331081346.GA5349@localhost>
In-Reply-To: <20140331081346.GA5349@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2014 11:13 AM, Fengguang Wu wrote:
> On Mon, Mar 31, 2014 at 10:08:51AM +0300, Boaz Harrosh wrote:
>> Sorry about that I forgot about the experimental rule, fixed now.
>>
>> Is there a way for a white list. With -experimental I need to say
>> every branch I do not want included is there a way to say only
>> the branches I do want included?
> 
> Yes, sure. You can tell me a list of branch patterns that is suitable
> for testing and I can blacklist everything else in your tree.
> 
> Thanks,
> Fengguang
> 

Thanks Wu, I hate to be trouble. Am I the only one who has this
problem ? Its that I use this git tree also as a public development
tree, when need of collaboration.

For now it is good, I'll try to remember when I push new branches

Thanks
Boaz

