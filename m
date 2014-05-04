Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614AbaEDBUf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 21:20:35 -0400
Received: from linuxhacker.ru ([217.76.32.60]:52766 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753557AbaEDBUe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 21:20:34 -0400
Subject: Re: [PATCH] staging/lustre: Replace jobid acquiring with per node setting
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Oleg Drokin <green@linuxhacker.ru>
In-Reply-To: <20140503232945.GA15714@kroah.com>
Date: Sat, 3 May 2014 21:20:06 -0400
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Andreas Dilger <andreas.dilger@intel.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <AD08F6C5-1BAD-455B-9A09-1FFB8D2CA42E@linuxhacker.ru>
References: <1398651712-5015-1-git-send-email-green@linuxhacker.ru> <20140503232945.GA15714@kroah.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 3, 2014, at 7:29 PM, Greg Kroah-Hartman wrote:

> On Sun, Apr 27, 2014 at 10:21:52PM -0400, Oleg Drokin wrote:
>> Insted of meddling directly in process environment variables
>> (which is also not possible on certain platforms due to not exported
>> symbols), create jobid_name proc file to represent this info
>> (to be filled by job scheduler epilogue).
> That looks better, but what are you going to do about getting rid of all
> of these proc files?  Just move them all at once?  I really don't like
> the idea of adding new ones, and want a plan for what you all are going
> to do here moving forward.

What proc files are to referring to, if I may ask?
I don't think I saw complaints about proc files, the complaints I saw were mostly about
reading env variables directly and the like so that was the focus of this patch.
Did I miss some side discussion? Any pointers?

Thanks!

Bye,
    Oleg