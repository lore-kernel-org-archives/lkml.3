Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655Ab3HFWF1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 18:05:27 -0400
Received: from jesper.alarsen.net ([144.76.18.233]:52746 "EHLO
	mail.alarsen.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940Ab3HFWF1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 18:05:27 -0400
X-Greylist: delayed 616 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Aug 2013 18:05:26 EDT
Date: Tue, 06 Aug 2013 23:55:05 +0200
From: Anders Larsen <al@alarsen.net>
Subject: Re: kernel mailing list permalinks
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Shuah Khan <shuahkhan@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        postmaster@vger.kernel.org
In-Reply-To: <52016958.70005@zytor.com> (from hpa@zytor.com on Tue Aug  6
	23:23:36 2013)
X-Mailer: Balsa 2.4.1
Message-Id: <1375826105.22552.0@oscar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-08-06 23:23, H. Peter Anvin wrote:
> On 08/06/2013 02:11 PM, Bjorn Helgaas wrote:
> >>
> >> The above link is also a good example of subtleness: + in a URL  
> means a
> >> space character, it has to be escaped as %2B.  Particularly a  
> problem in
> >> gmail message-ids.

the link in question works just fine without escaping the +; the + only
has to be escaped in then query component of a URL, not in the path
component where it is just another valid character - and the link in
question did not contain any query component.

(see RFC 3986 sections 3.3 and 3.4)

> A quoted Message-ID might be weird as heck, but one rarely if ever see
> them, I don't know if they are even legal.

I don't think they are even possible, as the percent-sign is just  
another
valid character in a Message-ID - but so is the '+' sign, so it seems
you're trying to solve a non-existent problem...

(see RFC 5322 section 3.2.3)

Cheers
Anders
