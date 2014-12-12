Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966599AbaLLLl0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 06:41:26 -0500
Received: from laurent.telenet-ops.be ([195.130.137.89]:41905 "EHLO
	laurent.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966206AbaLLLlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 06:41:25 -0500
Message-ID: <548AD461.1020707@acm.org>
Date: Fri, 12 Dec 2014 12:41:21 +0100
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Akira Hayakawa <ruby.wktk@gmail.com>
CC: snitzer@redhat.com, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, thornber@redhat.com,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        Mark Ruijter <mruijter@gmail.com>
Subject: Re: [dm-devel] [PATCH v2] staging: writeboost: Add dm-writeboost
References: <54883195.1060304@gmail.com> <20141211152626.GA8196@redhat.com> <548A39E7.80508@gmail.com> <548AB172.4000103@acm.org> <548AB6E4.2020302@gmail.com>
In-Reply-To: <548AB6E4.2020302@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/14 10:35, Akira Hayakawa wrote:
> Writeboost batches number of writes into a log (that is 512KB large) and submits to SSD
> which maximizes the throughput and the lifetime of the SSD.

Does this mean that dm-writeboost is similar to btier ? If so, this 
makes me wonder which of these two subsystems would be the best 
candidate for upstream inclusion. As far as I know btier doesn't split 
bio's. The source code of btier can be downloaded from 
http://sourceforge.net/projects/tier/.

Bart.

