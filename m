Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552AbaB0X2p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 18:28:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40490 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbaB0X2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 18:28:44 -0500
Date: Thu, 27 Feb 2014 15:28:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>, Jerome Marchand <jmarchan@redhat.com>,
        Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv8 6/6] zram: document max_comp_streams
Message-Id: <20140227152843.2756654c89256506431ca0d4@linux-foundation.org>
In-Reply-To: <1393417679-13657-7-git-send-email-sergey.senozhatsky@gmail.com>
References: <1393417679-13657-1-git-send-email-sergey.senozhatsky@gmail.com>
	<1393417679-13657-7-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Feb 2014 15:27:59 +0300 Sergey Senozhatsky <sergey.senozhatsky@gmail.com> wrote:

> Add max_comp_streams device attribute documentation.

Ah, there it is.  It's better to include the doc additions in the same
patch as the code additions, IMO.  All nice and atomic.

