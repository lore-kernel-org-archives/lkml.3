Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096AbaIBUrr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 16:47:47 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58396 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbaIBUrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 16:47:45 -0400
Date: Tue, 02 Sep 2014 13:47:44 -0700 (PDT)
Message-Id: <20140902.134744.131350267341788920.davem@davemloft.net>
To: devel@dtwood.uk
Cc: netdev@vger.kernel.org, agordeev@redhat.com, ebiederm@xmission.com,
        ao2@ao2.it, paul.gortmaker@windriver.com, jiri@resnulli.us,
        jeffrey.t.kirsher@intel.com, w-lkml@lebenslange-mailadresse.de,
        ivecera@redhat.com, linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] ethernet: nvidia: Remove extra parens
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140901223152.GA3066@dtw-laptop.attlocal.net>
References: <20140901223152.GA3066@dtw-laptop.attlocal.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 02 Sep 2014 13:47:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Wood <devel@dtwood.uk>
Date: Mon, 1 Sep 2014 15:31:55 -0700

> Remove unnecessary double parenthesis around if statement.
> 
> Signed-off-by: David Wood <devel@dtwood.uk>

Applied, thank you.
