Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126AbaEDDIu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 23:08:50 -0400
Received: from linuxhacker.ru ([217.76.32.60]:53328 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932111AbaEDDIt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 23:08:49 -0400
Subject: Re: [PATCH] staging/lustre: Replace jobid acquiring with per node setting
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Oleg Drokin <green@linuxhacker.ru>
In-Reply-To: <20140504023331.GB30871@kroah.com>
Date: Sat, 3 May 2014 23:08:36 -0400
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Andreas Dilger <andreas.dilger@intel.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <D18938B7-4D28-4312-8154-B5AE964ECEE4@linuxhacker.ru>
References: <1398651712-5015-1-git-send-email-green@linuxhacker.ru> <20140503232945.GA15714@kroah.com> <AD08F6C5-1BAD-455B-9A09-1FFB8D2CA42E@linuxhacker.ru> <20140504023331.GB30871@kroah.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

On May 3, 2014, at 10:33 PM, Greg Kroah-Hartman wrote:
>> I don't think I saw complaints about proc files, the complaints I saw were mostly about
>> reading env variables directly and the like so that was the focus of this patch.
>> Did I miss some side discussion? Any pointers?
> No, no side discussion, the proc files need to be removed / fixed before
> the code can be merged to the "proper" part of the kernel tree.

So, what's broken about them then?
It's not like there are no files in proc or that lustre-proc files are causing some
sort of breakage (at least not anymore after that recent patch).

So some guidance would be really appreciated.

Bye,
    Oleg