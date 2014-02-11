Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234AbaBKRzm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 12:55:42 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:14940 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751870AbaBKRzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 12:55:40 -0500
Message-ID: <1392141339.3380.49.camel@hornet>
Subject: Re: [PATCH v2 1/2] mfd: syscon: Add platform data with a regmap
 config name
From: Pawel Moll <pawel.moll@arm.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, "arm@kernel.org" <arm@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 11 Feb 2014 17:55:39 +0000
In-Reply-To: <1392141165-14338-1-git-send-email-pawel.moll@arm.com>
References: <20140211174829.GJ15081@lee--X1>
	 <1392141165-14338-1-git-send-email-pawel.moll@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-11 at 17:52 +0000, Pawel Moll wrote:
> +	        const char *label;

Obviously should be a single tab only:

+       const char *label;

Pawel

