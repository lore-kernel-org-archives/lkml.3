Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbaCSUFL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 16:05:11 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38428 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbaCSUFJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 16:05:09 -0400
Date: Wed, 19 Mar 2014 16:05:08 -0400 (EDT)
Message-Id: <20140319.160508.1651223181779271745.davem@davemloft.net>
To: bjorn@mork.no
Cc: benchan@chromium.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org, oliver@neukum.org,
        gregkh@linuxfoundation.org, gsuarez@smithmicro.com
Subject: Re: [PATCH v3 1/2] USB: cdc: add MBIM extended functional
 descriptor structure
From: David Miller <davem@davemloft.net>
In-Reply-To: <87wqfrkioi.fsf@nemi.mork.no>
References: <1395115145-31821-1-git-send-email-benchan@chromium.org>
	<87wqfrkioi.fsf@nemi.mork.no>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Mar 2014 13:05:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bjørn Mork <bjorn@mork.no>
Date: Tue, 18 Mar 2014 09:35:57 +0100

> Or will patchwork keep track of tags across different patch
> versions?

It doesn't, and should not.  It has no idea if the patch changed or
not, the ACK'er might not still agree with the patch if any changes
were made.
