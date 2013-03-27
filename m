Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117Ab3C0Kkv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 06:40:51 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55184 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754447Ab3C0Kku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 06:40:50 -0400
Message-Id: <1364380849.29356.140661209776393.5C78F6D2@webmail.messagingengine.com>
X-Sasl-Enc: J9ZtbCulAJ/KepvfQp+NwXIjtwkcR0zszSlrURIcPlDd 1364380849
From: Robert Norris <robn@fastmail.fm>
To: li guang <lig.fnst@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Mailer: MessagingEngine.com Webmail Interface - ajax-86438d1f
In-Reply-To: <1364355774.31713.30.camel@liguang.fnst.cn.fujitsu.com>
References: <20130327015540.GA27623@pyro.melbourne.osa>
 <1364355774.31713.30.camel@liguang.fnst.cn.fujitsu.com>
Subject: Re: PROBLEM: All CPUs in soft lockup
Date: Wed, 27 Mar 2013 21:40:49 +1100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013, at 02:42 PM, li guang wrote:
> seems tasks are hogging your cpu/memory resource, did you check status
> your servicing processes?

According to my monitoring I have plenty of CPU and memory free at the
time the problem occurs. What specifically are you looking at the data I
provided that makes you think that?
