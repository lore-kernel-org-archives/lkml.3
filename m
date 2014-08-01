Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163AbaHAUcJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 16:32:09 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59571 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754818AbaHAUcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 16:32:06 -0400
Message-ID: <1406925121.2654.21.camel@jarvis>
Subject: Re: [ANNOUNCE] scsi patch queue tree updated
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 01 Aug 2014 16:32:01 -0400
In-Reply-To: <20140801122042.GA10771@infradead.org>
References: <20140708134003.GA7790@infradead.org>
	 <20140801122042.GA10771@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-08-01 at 05:20 -0700, Christoph Hellwig wrote:
> I've pushed out updates to both the core-for-3.17 and drivers-for-3.17
> branches.

So I'm afraid we missed the last -next build on these, so they can't go
in with the early SCSI pull.  I'm open to doing one mid merge window,
but Linus tends not to like that.

James


