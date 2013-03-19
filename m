Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934111Ab3CSUfr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 16:35:47 -0400
Received: from 95-31-19-74.broadband.corbina.ru ([95.31.19.74]:53371 "EHLO
	mail.izyk.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755298Ab3CSUfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 16:35:45 -0400
X-Greylist: delayed 524 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Mar 2013 16:35:45 EDT
Message-ID: <5148CA3A.7080804@izyk.ru>
Date: Wed, 20 Mar 2013 00:27:38 +0400
From: Ilya Zykov <linux@izyk.ru>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH 7/7] n_tty: Buffer work should not reschedule itself
References: <20130319141017.GB24900@kroah.com> <1363703218-32333-1-git-send-email-peter@hurleysoftware.com> <1363703218-32333-4-git-send-email-peter@hurleysoftware.com>
In-Reply-To: <1363703218-32333-4-git-send-email-peter@hurleysoftware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.03.2013 18:26, Peter Hurley wrote:
> Although the driver-side input path must update the available
> buffer space, it should not reschedule itself. If space is still
> available and the flip buffers are not empty, flush_to_ldisc()
> will loop again.
> 

Sounds reasonable to me.
Thank you.
Ilya Zykov <linux@izyk.ru>


