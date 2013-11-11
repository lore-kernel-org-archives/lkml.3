Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab3KKVZe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 16:25:34 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45254 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab3KKVZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 16:25:26 -0500
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH 0/5] percpu_ida: Various tweaks
From: Jens Axboe <axboe@kernel.dk>
X-Mailer: iPhone Mail (11B511)
In-Reply-To: <1384204833.12281.9.camel@haakon3.risingtidesystems.com>
Date: Mon, 11 Nov 2013 14:25:18 -0700
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Kent Overstreet <kmo@daterainc.com>, Oleg Nesterov <oleg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <1F29C616-F4BD-4BB8-9128-4B19AF490E9E@kernel.dk>
References: <20131028100440.GA5744@dhcp-26-207.brq.redhat.com> <1382995746.19256.756.camel@haakon3.risingtidesystems.com> <20131111193433.GA9679@dhcp-26-207.brq.redhat.com> <20131111193947.GD25231@kernel.dk> <1384204833.12281.9.camel@haakon3.risingtidesystems.com>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2013, at 14.20, "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> 
>> On Mon, 2013-11-11 at 12:39 -0700, Jens Axboe wrote:
>>> On Mon, Nov 11 2013, Alexander Gordeev wrote:
>>>> On Mon, Oct 28, 2013 at 02:29:06PM -0700, Nicholas A. Bellinger wrote:
>>>> I'll wait for Kent's feedback on these, and end-up dropping the
>>>> blk-mq-tag part from Patch #5 for the moment..
>>> 
>>> Hi Nicholas,
>>> 
>>> I am bit uncertain regarding the process concerning your and Jens trees.
>>> Are you planning to pull Shaohua's percpu_ida conversion?
>> 
>> The submitted blk-mq bits have the conversion, the old tagging is no
>> longer active/maintained. So any work on this going forward will have to
>> be based on the percpu ida conversion.
> 
> What Jen's said..

I'm going to start calling you Nick, if you keep misspelling my name. 

Jens
