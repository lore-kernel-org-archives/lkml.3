Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758794Ab3EGQMz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 12:12:55 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:44683 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758406Ab3EGQMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 12:12:53 -0400
X-Authority-Analysis: v=2.0 cv=cYNQXw/M c=1 sm=0 a=/DbS/tiKggfTkRRHPZEB4g==:17 a=Qsx_du5GiBkA:10 a=_nfIMGA1H_4A:10 a=dwL0LKpTL8MA:10 a=S1A5HrydsesA:10 a=8nJEP1OIZ-IA:10 a=fxJcL_dCAAAA:8 a=LH0XCIorE3gA:10 a=danhDmx_AAAA:8 a=QfKxxUxMAAAA:8 a=e9Qf2inN8DrP42hG1K8A:9 a=wPNLvfGTeEIA:10 a=/DbS/tiKggfTkRRHPZEB4g==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.78.168.186
Message-ID: <51892802.6090707@ubuntu.com>
Date: Tue, 07 May 2013 12:12:50 -0400
From: Phillip Susi <psusi@ubuntu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Robert Hancock <hancockrwd@gmail.com>,
        "Artem S. Tashkinov" <t.artem@lycos.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Abysmal HDD/USB write speed after sleep on a UEFI system
References: <CAErSpo7qj2SNR7BfuBsfF-saZXvgcqqLtgoP5Hyb5u99qR4Ncg@mail.gmail.com> <Pine.LNX.4.44L0.1302191119270.2215-100000@iolanthe.rowland.org> <CAErSpo7NZoOQZyW76HEoOTVgdqL2CgbVScAeF6HGLAVaNCq0=w@mail.gmail.com> <337833384.57445.1361860509194.JavaMail.mail@webmail08> <CAErSpo6CbO5KYXiErv6J_Dnm1u694C5fQPP2_cZL8VKDEnZa9A@mail.gmail.com> <569718148.80620.1361906088301.JavaMail.mail@webmail13> <CAErSpo6UkVhSf+nFW4zwJLBQw_0RQ5H9Bv-UuQRb6zdwsFPw4g@mail.gmail.com> <CAErSpo4X+XXKvWDfqh2CKZAtJ9WMQk91OcsWwdxwYv2MfEM_zQ@mail.gmail.com> <771333906.75854.1367057440028.JavaMail.mail@webmail08> <CAErSpo4B4sRco-nuqgXiYtGQxBcbEB6ArQjHD0A9cj4TRE+qQw@mail.gmail.com> <518097B8.4020402@gmail.com> <CAErSpo7KWPRVEnw+n068pUZz+=WSTwno6m6t7N6dunuhnFC8EA@mail.gmail.com>
In-Reply-To: <CAErSpo7KWPRVEnw+n068pUZz+=WSTwno6m6t7N6dunuhnFC8EA@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 5/7/2013 11:25 AM, Bjorn Helgaas wrote:
> Phillip, I cc'd you because you have similar hardware and your 
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1131468 report
> is slightly similar.  Have you seen anything like this "reduced 
> performance after resume" issue?  If so, can you collect
> /proc/mtrr contents before and after suspending?

Nope, not seen that issue.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJRiSgCAAoJEJrBOlT6nu75e0IH/1tqoTRyAMfVgcWTfhdcSAVi
kBnvTpfGqlwD1ThxF3AZ+kHFPykI7TNUEvPR+syBFIi6BLHDoCZJMyCnKWwrY3jW
62lpgBZPZNejK+Yms3wjt6bZs81g38FKhWqm/IGruo7u79j/CS6puUypQMZ7WkC4
8y3SjBfiVy3ncQAOr7akCJzCv4fgqY+vtpIOHOXknfUxwgHqVOo3Pa0rMeat2TrN
8KHLkzYjML7Z+vN9DvPnqnRYFwFmkRZl01wRITo3OaFFJFhH70uqnwZ3ES+H0oh5
OpAJqEZ1PqiSAn+P7nI8RJ8lt7c5bta6Mvv0ev4+aDOQxnL3AmipOMNGfI37Ubk=
=fiiM
-----END PGP SIGNATURE-----
