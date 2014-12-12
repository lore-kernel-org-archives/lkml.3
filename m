Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934762AbaLLJfk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 04:35:40 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:41488 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934091AbaLLJfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 04:35:38 -0500
Message-ID: <548AB6E4.2020302@gmail.com>
Date: Fri, 12 Dec 2014 18:35:32 +0900
From: Akira Hayakawa <ruby.wktk@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: bvanassche@acm.org
CC: snitzer@redhat.com, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, thornber@redhat.com,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v2] staging: writeboost: Add dm-writeboost
References: <54883195.1060304@gmail.com> <20141211152626.GA8196@redhat.com> <548A39E7.80508@gmail.com> <548AB172.4000103@acm.org>
In-Reply-To: <548AB172.4000103@acm.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/14 6:12 PM, Bart Van Assche wrote:
> This is the first time I see someone claiming that reducing the request size improves performance. I don't know any SSD model for which splitting requests improves performance.

Writeboost batches number of writes into a log (that is 512KB large) and submits to SSD
which maximizes the throughput and the lifetime of the SSD.
I think you fairly misunderstand how Writeboost works.

- Akira
