Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600AbaJMVDt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 17:03:49 -0400
Received: from ns.horizon.com ([71.41.210.147]:18402 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751188AbaJMVDs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 17:03:48 -0400
Date: 13 Oct 2014 17:03:46 -0400
Message-ID: <20141013210346.31360.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: gregkh@linuxfoundation.org, romain@orebokech.com
Subject: Re: [PATCH 3.17 00/25] 3.17.1-stable review
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux@horizon.com,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org, tj@kernel.org, torvalds@linux-foundation.org
In-Reply-To: <87d29w6kl8.fsf@kima.orebokech.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Romain Francoise <romain@orebokech.com> wrote:
> Commit 1c40279960 ("libata: Un-break ATA blacklist") is apparently not
> included, is in Linus' tree since Friday, and is rather urgent.

As the patch author, I agree.  If nothing else, I'd like to be able to take
off this brown paper bag.
