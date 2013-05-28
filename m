Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634Ab3E1UIn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 16:08:43 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:60450 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755033Ab3E1UIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 16:08:41 -0400
X-Authority-Analysis: v=2.0 cv=Xpd4yC59 c=1 sm=0 a=/DbS/tiKggfTkRRHPZEB4g==:17 a=Qsx_du5GiBkA:10 a=bfzWQn4VrGAA:10 a=xorsMp-LQb0A:10 a=S1A5HrydsesA:10 a=IkcTkHD0fZMA:10 a=fxJcL_dCAAAA:8 a=d66X4gvnlFEA:10 a=QfKxxUxMAAAA:8 a=V5q5d3fyYX60JFsPVPwA:9 a=QEXdDO2ut3YA:10 a=/DbS/tiKggfTkRRHPZEB4g==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.78.168.186
Message-ID: <51A50EC4.4090108@ubuntu.com>
Date: Tue, 28 May 2013 16:08:36 -0400
From: Phillip Susi <psusi@ubuntu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: Simon Jeons <simon.jeons@gmail.com>, akpm@linux-foundation.org,
        mgorman@suse.de, matthew.garrett@nebula.com, dave@sr71.net,
        rientjes@google.com, riel@redhat.com, arjan@linux.intel.com,
        srinivas.pandruvada@linux.intel.com, maxime.coquelin@stericsson.com,
        loic.pallardy@stericsson.com, kamezawa.hiroyu@jp.fujitsu.com,
        lenb@kernel.org, rjw@sisk.pl, gargankita@gmail.com,
        paulmck@linux.vnet.ibm.com, amit.kachhap@linaro.org,
        svaidy@linux.vnet.ibm.com, andi@firstfloor.org, wujianguo@huawei.com,
        kmpark@infradead.org, thomas.abraham@linaro.org,
        santosh.shilimkar@ti.com, linux-pm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 00/15][Sorted-buddy] mm: Memory Power Management
References: <20130409214443.4500.44168.stgit@srivatsabhat.in.ibm.com> <5170D781.3000102@gmail.com> <5170EE4F.9030908@linux.vnet.ibm.com>
In-Reply-To: <5170EE4F.9030908@linux.vnet.ibm.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 4/19/2013 3:12 AM, Srivatsa S. Bhat wrote:
> But going further, as I had mentioned in my TODO list, we can be
> smarter than this while doing compaction to evacuate memory regions
> - we can choose to migrate only the active pages, and leave the
> inactive pages alone. Because, the goal is to actually consolidate
> the *references* and not necessarily the *allocations* themselves.

That would help with keeping references compact to allow use of the
low power states, but it would also be nice to keep allocations
compact, and completely power off a bank of ram with no allocations.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJRpQ7EAAoJEJrBOlT6nu75wqYH/Aq18xGwk3QCJPEBb3BQX4be
NY0JfHH9sHE7CFH4t13qpwNj/+N73xBg+TumY2qekUxqfwYSRo3hDhPRonlW/eDI
X2AaEGDs8+aQT+QY8bAZnZFHFX8ZayNYOsNCewEV8djZDll2l+fOaFjVfZAwuQLK
KtsMxjhlTzqMleRxVpZFLtVPG4GzLRITifKlBRQ+ffrO1zTTMI7glvM+IygIa5vS
ajOCI0Nis1Rst2cOsrxfWc+DKN+gnI6c/qTsHarPD5zda1AFwe9DzWQ7EGiqnbJq
39vJmGIsspwrEPbaK0VX5dVYp85Bvd03EudeEish4EHVmH+hphpFokxoypRJePg=
=Flf3
-----END PGP SIGNATURE-----
