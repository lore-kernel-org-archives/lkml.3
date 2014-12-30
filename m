Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761AbaL3Ny4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 08:54:56 -0500
Received: from mail-qg0-f44.google.com ([209.85.192.44]:49363 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbaL3Nyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 08:54:55 -0500
Message-ID: <54A2AEA8.7060204@hurleysoftware.com>
Date: Tue, 30 Dec 2014 08:54:48 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH] soc: Remove duplicate Kconfig include
References: <1419947424-9555-1-git-send-email-peter@hurleysoftware.com>
In-Reply-To: <1419947424-9555-1-git-send-email-peter@hurleysoftware.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/30/2014 08:50 AM, Peter Hurley wrote:
> commit 3a6e08218f36baa9c49282ad2fe0dfbf001d8f23
> ("soc: Introduce drivers/soc place-holder for SOC specific drivers")
> added a duplicate source for soc Kconfig, which had already been
> introduced by commit 41f93af900a20d1a0a358b522b5129c89677e9dc
> ("soc: ti: add Keystone Navigator QMSS driver").

Greg,

Would you take this patch please? Both Santosh and Sandeep's emails
bounced.

Regards,
Peter Hurley
