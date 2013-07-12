Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755Ab3GLTxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 15:53:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12986 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083Ab3GLTxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 15:53:19 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=HICIQ9bjhMYA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=PINbNDQYIjoA:10 a=5rZ7WBBEjUFlVpMJqzkA:9 a=QEXdDO2ut3YA:10 a=UkN_hamDBtMA:10 a=WxxjjqhpVtUA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1373658797.17876.119.camel@gandalf.local.home>
Subject: Re: [Ksummit-2013-discuss] When to push bug fixes to mainline
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ksummit-2013-discuss@lists.linux-foundation.org
Date: Fri, 12 Jul 2013 15:53:17 -0400
In-Reply-To: <CA+55aFw0PvYBguFmacL0FC6V_hjGVcUWsrZ6HO9tuQof=yw5PA@mail.gmail.com>
References: <20130711214830.611455274@linuxfoundation.org>
	 <20130712005023.GB31005@thunk.org> <20130712025745.GA24086@tuxdriver.com>
	 <20130712033430.GA3798@kroah.com> <51E03AEE.5010403@zytor.com>
	 <20130712172836.GA7627@kroah.com> <20130712175718.GA342@thunk.org>
	 <51E0480A.2040905@zytor.com> <51E04AB9.1000003@zytor.com>
	 <CA+55aFw0PvYBguFmacL0FC6V_hjGVcUWsrZ6HO9tuQof=yw5PA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-07-12 at 12:44 -0700, Linus Torvalds wrote:

> They can be useful for "local" notes (they can be very powerful for
> certain workflows), but they won't be pulled and pushed by me.

Perhaps notes can be used as that reminder to send to stable. Tag a
commit with a note, and have some automated process that monitors
Linus's tree and when a commit makes it in, automate an email to stable
with said commit.

-- Steve


