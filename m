Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756977Ab3HFXPl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 19:15:41 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:36159 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755342Ab3HFXPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 19:15:38 -0400
Message-ID: <1375830937.2424.41.camel@joe-AO722>
Subject: Re: kernel mailing list permalinks
From: Joe Perches <joe@perches.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Anders Larsen <al@alarsen.net>, Bjorn Helgaas <bhelgaas@google.com>,
        Shuah Khan <shuahkhan@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        postmaster@vger.kernel.org, Konstantin Ryabitsev <mricon@kernel.org>
Date: Tue, 06 Aug 2013 16:15:37 -0700
In-Reply-To: <5201813F.1070102@zytor.com>
References: <1375826105.22552.0@oscar> <5201813F.1070102@zytor.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-06 at 16:05 -0700, H. Peter Anvin wrote:
> On 08/06/2013 02:55 PM, Anders Larsen wrote:
> > On 2013-08-06 23:23, H. Peter Anvin wrote:
> >> On 08/06/2013 02:11 PM, Bjorn Helgaas wrote:
> >> >>
> >> >> The above link is also a good example of subtleness: + in a URL
> >> means a
> >> >> space character, it has to be escaped as %2B.  Particularly a
> >> problem in
> >> >> gmail message-ids.
> > 
> > the link in question works just fine without escaping the +; the + only
> > has to be escaped in then query component of a URL, not in the path
> > component where it is just another valid character - and the link in
> > question did not contain any query component.
> > 
> > (see RFC 3986 sections 3.3 and 3.4)

Rather than relying on third party links,
it'd be nice if vger was the archive too.

