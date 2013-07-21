Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109Ab3GUUjf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 16:39:35 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:55272 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756011Ab3GUUje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 16:39:34 -0400
Message-ID: <51EC4701.8020502@cogentembedded.com>
Date: Mon, 22 Jul 2013 00:39:29 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: catalin.marinas@arm.com, xen-devel@lists.xensource.com,
        marc.zyngier@arm.com, konrad.wilk@oracle.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] xen/arm and xen/arm64: update xen_restart after ff701306cd49
References: <1374420257-19467-1-git-send-email-stefano.stabellini@eu.citrix.com>
In-Reply-To: <1374420257-19467-1-git-send-email-stefano.stabellini@eu.citrix.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 21-07-2013 19:24, Stefano Stabellini wrote:

> Commit ff701306cd49 changes the prototype of arm_pm_restart.

    Please also specify the summary line of that commit in parens.

> Update xen_restart accordingly.

> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

WBR, Sergei

