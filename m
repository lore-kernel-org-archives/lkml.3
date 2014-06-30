Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550AbaF3QYK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 12:24:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39441 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbaF3QYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 12:24:09 -0400
Date: Mon, 30 Jun 2014 09:23:54 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Don A. Bailey" <donb@securitymouse.com>
Cc: Richard Weinberger <richard@nod.at>,
        Markus Oberhumer <markus@oberhumer.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: lzo1x_decompress_safe: Macro compares unsigned to 0 (NO_EFFECT)
Message-ID: <20140630162354.GB24179@kroah.com>
References: <53b0f0f715b96_146f12c1338333fa@209.249.196.67.mail>
 <53B11047.3000105@nod.at>
 <20140630143745.GA22623@kroah.com>
 <CAFkuX4uoMFC1jT4Oeqj3HzfPWG3JFiEnysODEopfL8aQod4_mQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFkuX4uoMFC1jT4Oeqj3HzfPWG3JFiEnysODEopfL8aQod4_mQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 09:34:44AM -0600, Don A. Bailey wrote:
> In the case of macro instances that include a '0', the overflow test is
> purposefully benign. We don't need a test for these cases. It was easy to throw
> a '0' in there to accommodate for the new two-param call. But, to appease
> Coverity, a second single-param macro that doesn't check for overflow could be
> created. 

Not needed, we don't need to "apease" coverity :)

Let's just leave this as-is.

thanks,

greg k-h
