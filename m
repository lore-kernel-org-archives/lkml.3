Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933505Ab3DKDWo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 23:22:44 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:55774 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755650Ab3DKDWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 23:22:43 -0400
Date: Wed, 10 Apr 2013 23:22:41 -0400 (EDT)
Message-Id: <20130410.232241.1038793023507666278.davem@davemloft.net>
To: petkan@nucleusys.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sarah.a.sharp@linux.intel.com
Subject: Re: [PATCH] net: usb: active URB submitted multiple times
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.DEB.2.02.1304102354010.9358@fry>
References: <alpine.DEB.2.02.1304102354010.9358@fry>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Wed, 10 Apr 2013 20:22:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I think you need to read Documentation/SubmittingPatches, and
Documentation/email-clients.txt

Do not submit the diff for the individual files seperately,
provide all the changes together as a single patch.

Do not use an attachment, instead provide your patch inline
as plain ASCII, unformatted text.
