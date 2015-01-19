Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442AbbASU4e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 15:56:34 -0500
Received: from smtp2.provo.novell.com ([137.65.250.81]:44988 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbbASU4c (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Mon, 19 Jan 2015 15:56:32 -0500
Message-ID: <1421700987.4903.9.camel@stgolabs.net>
Subject: Re: ia64: use current->state helpers
From: Davidlohr Bueso <dave@stgolabs.net>
To: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>, linux-kernel@vger.kernel.org,
        linux-ia64@vger.kernel.org
Date: Mon, 19 Jan 2015 12:56:27 -0800
In-Reply-To: <1421308200.17403.3.camel@stgolabs.net>
References: <1421308200.17403.3.camel@stgolabs.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2015-01-14 at 23:50 -0800, Davidlohr Bueso wrote:
> Call __set_current_state() instead of assigning the new state directly.
> These interfaces also aid CONFIG_DEBUG_ATOMIC_SLEEP environments, keeping
> track of who changed the state.

ping?


