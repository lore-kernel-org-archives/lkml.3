Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155Ab3B1WSe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 17:18:34 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:54633 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752765Ab3B1WSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 17:18:33 -0500
Message-ID: <512FD7B2.40901@linux.vnet.ibm.com>
Date: Thu, 28 Feb 2013 14:18:26 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: jlmales@gmail.com
CC: linux-kernel@vger.kernel.org
Subject: Re: Linux Kernel Commit 025cee7f8fef02af09b03c8e1cd9843cb32adf9b
References: <20130228171143.5c32726d.jlmales@gmail.com>
In-Reply-To: <20130228171143.5c32726d.jlmales@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022822-9360-0000-0000-0000111F5C41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2013 02:11 PM, John L. Males wrote:
> Would the Linux Kernel under "unique" Virtual Memory Subsystem
> stress excite some of these "subtle bugs" in Linux Kernels
> prior to this change set for Commit
> 025cee7f8fef02af09b03c8e1cd9843cb32adf9b?

I don't think stress would really do it.

It also, as far as I know, only applies to 32-bit NUMA kernels where
CONFIG_NUMA was turned on _and_ where the machine actually was NUMA.

