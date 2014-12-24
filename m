Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160AbaLXOoJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 09:44:09 -0500
Received: from kanga.kvack.org ([205.233.56.17]:57611 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893AbaLXOoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 09:44:07 -0500
Date: Wed, 24 Dec 2014 09:44:06 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: Fam Zheng <famz@redhat.com>
Cc: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [v3.19-rc1] read_events => aio_read_events => WARNING: "do not call blocking ops when !TASK_RUNNING"
Message-ID: <20141224144406.GF17185@kvack.org>
References: <87oaqvhoir.fsf@nemi.mork.no> <20141224065002.GA15614@ad.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141224065002.GA15614@ad.nay.redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 24, 2014 at 02:50:02PM +0800, Fam Zheng wrote:
> Could you trace down to the source code context of this io_getevents call in
> mysqld?  The change merely made io_getevents return a lot more quickly than
> before, so it seems like that a polling loop is spinning too fast as a result.

This warning is unrelated to your changes -- see my email exchange with Chris 
Mason for the details.

		-ben
-- 
"Thought is the essence of where you are now."
