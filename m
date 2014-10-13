Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227AbaJMPxm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 11:53:42 -0400
Received: from stringer.orebokech.com ([212.83.175.182]:40653 "EHLO
	stringer.orebokech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328AbaJMPxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 11:53:41 -0400
X-Greylist: delayed 576 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Oct 2014 11:53:40 EDT
From: Romain Francoise <romain@orebokech.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        George Spelvin <linux@horizon.com>
Subject: Re: [PATCH 3.17 00/25] 3.17.1-stable review
Organization: orebokech dot com
References: <20141013022454.289398272@linuxfoundation.org>
Date: Mon, 13 Oct 2014 17:44:03 +0200
In-Reply-To: <20141013022454.289398272@linuxfoundation.org> (Greg
	Kroah-Hartman's message of "Mon, 13 Oct 2014 04:24:53 +0200")
Message-ID: <87d29w6kl8.fsf@kima.orebokech.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2014 at 04:24:53AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.17.1 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Commit 1c40279960 ("libata: Un-break ATA blacklist") is apparently not
included, is in Linus' tree since Friday, and is rather urgent.
