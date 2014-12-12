Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935192AbaLLRxb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 12:53:31 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:51106 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934073AbaLLRx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 12:53:29 -0500
Message-ID: <548B2B97.5020105@hurleysoftware.com>
Date: Fri, 12 Dec 2014 12:53:27 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Imre Deak <imre.deak@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] vt: fix locking around vt_bind/vt_unbind
References: <1418402285-9578-1-git-send-email-imre.deak@intel.com> <1418402285-9578-2-git-send-email-imre.deak@intel.com>
In-Reply-To: <1418402285-9578-2-git-send-email-imre.deak@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2014 11:38 AM, Imre Deak wrote:
> Currently vt_bind and vt_unbind access at least the con_driver object
> and registered_con_driver array without holding the console lock. Fix
> this by locking around the whole function in each case.

Reviewed-by: Peter Hurley <peter@hurleysoftware.com>


