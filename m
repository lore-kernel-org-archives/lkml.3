Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211AbbAFDMe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 22:12:34 -0500
Received: from rrcs-76-79-27-186.west.biz.rr.com ([76.79.27.186]:24347 "EHLO
	rrcs-76-79-27-186.west.biz.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753352AbbAFDMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 22:12:33 -0500
Date: Mon, 5 Jan 2015 21:12:29 -0600
From: Jeff Epler <jepler@unpythonic.net>
To: linux-kernel@vger.kernel.org
Subject: What are these weird line-noise signatures?
Message-ID: <20150106025749.GA41958@unpythonic.net>
References: <1415624983-22413-1-git-send-email-kever.yang@rock-chips.com>
 <CAD=FV=V-D3qTtnwjme8k=boUkoGGPmfvcF=Jboq0qcRBzKrY6g@mail.gmail.com>
 <5463FE5E.906@rock-chips.com>
 <A2CA0424C0A6F04399FB9E1CD98E0304845059B3@US01WEMBX2.internal.synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <A2CA0424C0A6F04399FB9E1CD98E0304845059B3@US01WEMBX2.internal.synopsys.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have seen similar "signatures" that have the appearance of good old
fashioned line noise, such as in this recent message from Paul
Zimmerman (but not in all of his messages either!):

On Tue, Jan 06, 2015 at 01:23:30AM +0000, Paul Zimmerman wrote:
[real content snipped]
> -- 
> Paul
> 
> N?????r??y????b?X??ǧv?^?){.n?+????{????zX??^W??ܨ}???Ơz?&j:+v???^G????zZ+??+zf???h???~????i???z?^^?w?????????&?)ߢ^[f??^jǫy?m??@A?a??^??^L0??h?^O??i^?
(some characters were control characters and are represented with carets
above, and my mailreader seems to have transcoded other non-ASCIIs as
reencoded by my mailreader, but it's hard to be sure)

I have seen them from senders at various domains, and they are not some
kind of artifact of my own mail system because they appear in the
archives e.g., at

http://article.gmane.org/gmane.linux.usb.general/120149

and similarly in a 2014 message from another poster at another domain:
[real content snipped again]
> > Please read the FAQ at  http://www.tux.org/lkml/
> N?????r??y????b?X??ǧv?^?) .n?+????{????zX??^W??ܨ}???Ơz?&j:+v???^G????zZ+??+zf???h???~????i???z?^^?w?????????&?)ߢ^[f??^jǫy?m??@A?a??^??^L0??h?^O??i^?

http://mid.gmane.org/CD2CABCB2C0A0D4682C5F8AD8401415409741D%40HKXPRD3002MB006.064d.mgd.msft.net

[not quite byte-for-byte identical, but very close!]

Does anyone know what the purpose of these footers is?  Highly
compressed legal disclaimer, I'm guessing.

Jeff
