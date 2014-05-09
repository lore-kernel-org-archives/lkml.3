Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256AbaEIBRs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 21:17:48 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:63817 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932182AbaEIBRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 21:17:47 -0400
Message-ID: <536C2CB7.1060600@converseincode.com>
Date: Thu, 08 May 2014 18:17:43 -0700
From: Behan Webster <behanw@converseincode.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Subject: Re: [PATCH] mpilib: use 'static inline' for mpi-inline.h
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de>	<1399560990-1402858-1-git-send-email-arnd@arndb.de>	<1399560990-1402858-9-git-send-email-arnd@arndb.de> <20140508113013.74b2eb9d@gandalf.local.home>
In-Reply-To: <20140508113013.74b2eb9d@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/14 08:30, Steven Rostedt wrote:
> On Thu,  8 May 2014 16:56:20 +0200
> Arnd Bergmann <arnd@arndb.de> wrote:
>
>> Four functions of mpilib are defined as 'extern inline' at the
>> moment, which is generally not the correct way to do inline functions
>> using gcc.
> I think clang would appreciate this too.
Indeed. Saves me writing the same patch. :)

Behan

-- 
Behan Webster
behanw@converseincode.com

