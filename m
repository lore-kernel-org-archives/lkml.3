Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783Ab3F0RmW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 13:42:22 -0400
Received: from mga03.intel.com ([143.182.124.21]:12673 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753637Ab3F0RmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 13:42:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,953,1363158000"; 
   d="scan'208";a="261020784"
Date: Thu, 27 Jun 2013 19:41:11 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Ankur Raina <Ankur.Raina@kpitcummins.com>
Cc: "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "axel.lin@gmail.com" <axel.lin@gmail.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dchen@diasemi.com" <dchen@diasemi.com>
Subject: Re: [patch v1 1/1]mfd: fix for DA9055 driver initialization
Message-ID: <20130627174111.GG20292@zurbaran>
References: <4B6D9C89CD8BA349A71B74CA32C47E5850DA82AF@KCHJEXMB02.kpit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B6D9C89CD8BA349A71B74CA32C47E5850DA82AF@KCHJEXMB02.kpit.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ankur,

On Thu, Jun 27, 2013 at 02:06:45PM +0000, Ankur Raina wrote:
> This patch adds support for clearing events received while
> powering up DA9055.
Could you please explain what that fixes ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
